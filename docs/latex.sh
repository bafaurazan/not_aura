# Shared LaTeX helpers for docs/
#
#   source docs/latex.sh
#   buildtex docs/literature-review/
#   buildtex docs/thesis/
#   buildtex docs/literature-review/literatura.tex
#
# PDF stays next to the .tex; aux/log go to docs/build/

_docs_latex_root() {
  local src="${BASH_SOURCE[0]:-$0}"
  cd "$(dirname "$src")" && pwd
}

DOCS_ROOT="$(_docs_latex_root)"
unset -f _docs_latex_root

_docs_abs() {
  # Absolute path for a file or directory that exists.
  local target="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$target"
  else
    local dir base
    if [[ -d "$target" ]]; then
      (cd "$target" && pwd)
    else
      dir="$(cd "$(dirname "$target")" && pwd)"
      base="$(basename "$target")"
      printf '%s/%s\n' "$dir" "$base"
    fi
  fi
}

# Default .tex inside a project directory.
_docs_default_tex_in() {
  local dir="$1"
  if [[ -f "$dir/main.tex" ]]; then
    printf '%s\n' "$dir/main.tex"
    return 0
  fi
  if [[ -f "$dir/literatura.tex" ]]; then
    printf '%s\n' "$dir/literatura.tex"
    return 0
  fi
  local matches=( "$dir"/*.tex )
  if [[ ${#matches[@]} -eq 1 && -f "${matches[0]}" ]]; then
    printf '%s\n' "${matches[0]}"
    return 0
  fi
  echo "error: no default .tex in $dir (pass file explicitly)" >&2
  return 1
}

# Resolve arg → absolute path to .tex and project dir (both under DOCS_ROOT).
# Prints: "<abs_tex>\t<abs_project_dir>"
_docs_resolve_target() {
  local arg="${1:-}"
  local abs tex_abs project_abs

  if [[ -z "$arg" ]]; then
    project_abs="$PWD"
    tex_abs="$(_docs_default_tex_in "$project_abs")" || return 1
  elif [[ -d "$arg" ]]; then
    project_abs="$(_docs_abs "$arg")"
    tex_abs="$(_docs_default_tex_in "$project_abs")" || return 1
  elif [[ -f "$arg" ]]; then
    tex_abs="$(_docs_abs "$arg")"
    project_abs="$(cd "$(dirname "$tex_abs")" && pwd)"
  else
    echo "error: not a file or directory: $arg" >&2
    return 1
  fi

  case "$project_abs" in
    "$DOCS_ROOT"/*) ;;
    *)
      echo "error: target must be under $DOCS_ROOT" >&2
      echo "  got: $project_abs" >&2
      return 1
      ;;
  esac

  printf '%s\t%s\n' "$tex_abs" "$project_abs"
}

# Host path for Docker volume mounts (Git Bash → Windows).
_docs_docker_host_path() {
  local p="$1"
  # /c/Users/... → C:/Users/...
  if [[ "$p" =~ ^/([a-zA-Z])/(.*)$ ]]; then
    printf '%s:/%s\n' "$(echo "${BASH_REMATCH[1]}" | tr '[:lower:]' '[:upper:]')" "${BASH_REMATCH[2]}"
  else
    printf '%s\n' "$p"
  fi
}

buildtex() {
  local resolved tex_abs project_abs rel tex stem host_docs status

  resolved="$(_docs_resolve_target "${1:-}")" || return 1
  IFS=$'\t' read -r tex_abs project_abs <<<"$resolved"
  rel="${project_abs#"$DOCS_ROOT"/}"
  tex="$(basename "$tex_abs")"
  stem="${tex%.tex}"

  if ! command -v docker >/dev/null 2>&1; then
    echo "error: docker not found in PATH" >&2
    return 1
  fi

  mkdir -p "$DOCS_ROOT/build"
  host_docs="$(_docs_docker_host_path "$DOCS_ROOT")"

  echo "Building $rel/$tex ..."

  # MSYS_NO_PATHCONV: Git Bash must not rewrite /docs/... workdir to
  # C:/Program Files/Git/docs/...
  MSYS_NO_PATHCONV=1 docker run --rm \
    --volume "${host_docs}:/docs" \
    --workdir "/docs/${rel}" \
    texlive/texlive:latest \
    latexmk -pdf \
      -interaction=nonstopmode \
      -halt-on-error \
      -auxdir=/docs/build \
      -outdir=. \
      "$tex"
  status=$?

  if [[ $status -ne 0 ]]; then
    echo "error: build failed (exit $status); see $DOCS_ROOT/build/${stem}.log" >&2
    return "$status"
  fi

  echo "OK: $project_abs/${stem}.pdf"
  echo "    aux → $DOCS_ROOT/build/"
}

# If executed instead of sourced, run buildtex once.
if [[ "${BASH_SOURCE[0]:-$0}" == "$0" ]]; then
  set -euo pipefail
  buildtex "$@"
fi
