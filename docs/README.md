# Dokumentacja LaTeX (`docs/`)

Katalog zbiera materiały tekstowe projektu: pracę inżynierską oraz niezależny wykaz literatury dla promotora. Składanie PDF odbywa się przez Docker (obraz TeX Live) i makro `buildtex`.

## Układ

```text
docs/
├── README.md                 ← ten plik
├── latex.sh                  ← source → makro buildtex
├── .gitignore
├── build/                    ← artefakty składania (.aux, .log, …); nie commitować
├── literature-review/
│   └── literatura.tex        → literatura.pdf
└── thesis/
    ├── main.tex              → main.pdf
    ├── assets/logos/
    ├── content/              ← materiały robocze (nie dołączane ponownie)
    └── front-matter/
```

| Ścieżka | Rola |
| --- | --- |
| [`literature-review/`](literature-review/) | Opisowy wykaz literatury dla promotora (osobny dokument) |
| [`thesis/`](thesis/) | Źródła pracy inżynierskiej |
| [`latex.sh`](latex.sh) | Wspólne budowanie PDF |
| `build/` | Śmieci po kompilacji (`latexmk -auxdir`) |

PDF zawsze powstaje **obok** pliku `.tex`. Artefakty trafiają do **`docs/build/`**.

---

## Budowanie PDF

Wymagania: działający Docker oraz obraz `texlive/texlive` (pobierze się przy pierwszym buildzie).

Raz na sesję (z roota repo, Git Bash / Linux / macOS):

```bash
source docs/latex.sh
```

Potem z dowolnego katalogu:

```bash
buildtex docs/literature-review/
buildtex docs/thesis/

# albo konkretny plik:
buildtex docs/literature-review/literatura.tex
buildtex docs/thesis/main.tex
```

Jednorazowo bez sourcowania:

```bash
bash docs/latex.sh docs/thesis/
```

---

## Wykaz literatury (`literature-review/`)

Niezależny dokument [`literatura.tex`](literature-review/literatura.tex) — **nie** jest dołączany przez `thesis/main.tex`. Bibliografia drukowana w pracy siedzi bezpośrednio w `main.tex`; ten katalog służy do przedstawienia źródeł z opisami wykorzystania.

Wynik: `literature-review/literatura.pdf`.

---

## Praca inżynierska (`thesis/`)

Punkt wejścia: [`thesis/main.tex`](thesis/main.tex).

### Co jest używane w dokumencie

`main.tex` dołącza bezpośrednio:

- `front-matter/title-page-classic.tex` — domyślna strona tytułowa
- `front-matter/abstract.tex` — streszczenie PL/EN
- `front-matter/genai-disclosure.tex` — wykaz GenAI
- grafiki z `assets/logos/`

Alternatywa strony tytułowej: `front-matter/title-page-cover.tex` (okładka PRz). Przełączenie opisane komentarzem w `main.tex`.

Pliki w `content/` to zachowane materiały robocze; ich treść jest już w `main.tex`, więc nie są `\input`-owane ponownie (uniknięcie podwójnych rozdziałów).

### Mapowanie załączników źródłowych

| Załącznik | Miejsce w repozytorium |
| --- | --- |
| `Praca_magisterska.tex` | `thesis/main.tex` |
| `wstep.tex` | `thesis/content/introduction.tex` |
| `Rozdzial_1.tex` | `thesis/content/chapter-01.tex` |
| `Streszczenie.tex` | `thesis/front-matter/abstract.tex` |
| `tabela_genai.tex` | `thesis/front-matter/genai-disclosure.tex` |
| `strona_tytulowa-1.tex` | `thesis/front-matter/title-page-classic.tex` |
| `strona_tytulowa-2.tex` | `thesis/front-matter/title-page-cover.tex` |
| logo Politechniki Rzeszowskiej | `thesis/assets/logos/university.png` |
| logo wydziału | `thesis/assets/logos/faculty.png` |

Wynik: `thesis/main.pdf`.
