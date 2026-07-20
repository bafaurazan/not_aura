# Wykaz literatury dla promotora

Ten katalog jest niezależnym projektem LaTeX przeznaczonym do przedstawienia promotorowi wykorzystanych źródeł wraz z ich opisami.

Dokument [`literatura.tex`](literatura.tex) nie jest częścią pracy inżynierskiej i nie jest dołączany przez `docs/thesis/main.tex`. Bibliografia drukowana w pracy pozostaje zdefiniowana bezpośrednio w głównym dokumencie pracy.

## Budowanie PDF

Z tego katalogu można uruchomić lokalnie:

```powershell
latexmk -pdf literatura.tex
```

Albo użyć obrazu Docker z TeX Live:

```powershell
docker run --rm `
  --volume "${PWD}:/workdir" `
  --workdir /workdir `
  texlive/texlive:latest `
  latexmk -pdf -interaction=nonstopmode -halt-on-error literatura.tex
```

Wynikiem jest niezależny plik `literatura.pdf`.
