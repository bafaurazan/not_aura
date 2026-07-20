# Praca inżynierska

Katalog zawiera źródła dokumentu LaTeX oraz materiały pomocnicze. Punktem wejścia jest [`main.tex`](main.tex).

## Układ katalogów

```text
thesis/
├── main.tex
├── assets/
│   └── logos/
│       ├── faculty.png
│       └── university.png
├── content/
│   ├── chapter-01.tex
│   └── introduction.tex
├── front-matter/
│   ├── abstract.tex
│   ├── genai-disclosure.tex
│   ├── title-page-classic.tex
│   └── title-page-cover.tex
```

## Pliki używane przez dokument główny

`main.tex` korzysta bezpośrednio z:

- `front-matter/title-page-classic.tex` — domyślna strona tytułowa,
- `front-matter/abstract.tex` — streszczenie polskie i angielskie,
- `front-matter/genai-disclosure.tex` — wykaz wykorzystania narzędzi GenAI,
- grafik w `assets/logos/`.

Wariant `front-matter/title-page-cover.tex` jest zachowany jako alternatywna strona tytułowa dopasowana do okładki PRz. Sposób przełączenia wariantu opisano komentarzem w `main.tex`.

Pliki w `content/` są zachowanymi materiałami roboczymi. Ich treść występuje obecnie również bezpośrednio w `main.tex`, dlatego nie są dołączane ponownie — zapobiega to podwójnemu wyświetleniu rozdziałów.

Bibliografia przeznaczona do pracy jest już zapisana bezpośrednio w `main.tex`. Oddzielny, opisowy wykaz literatury dla promotora znajduje się poza tym projektem, w `docs/literature-review/`.

## Mapowanie załączonych plików

| Załącznik | Miejsce w repozytorium |
| --- | --- |
| `Praca_magisterska.tex` | `main.tex` |
| `wstep.tex` | `content/introduction.tex` |
| `Rozdzial_1.tex` | `content/chapter-01.tex` |
| `Streszczenie.tex` | `front-matter/abstract.tex` |
| `tabela_genai.tex` | `front-matter/genai-disclosure.tex` |
| `strona_tytulowa-1.tex` | `front-matter/title-page-classic.tex` |
| `strona_tytulowa-2.tex` | `front-matter/title-page-cover.tex` |
| logo Politechniki Rzeszowskiej | `assets/logos/university.png` |
| logo wydziału | `assets/logos/faculty.png` |

## Budowanie PDF

Polecenia należy uruchamiać z tego katalogu:

```powershell
latexmk -pdf main.tex
```

Jeśli `latexmk` nie jest dostępny, można dwukrotnie uruchomić:

```powershell
pdflatex main.tex
pdflatex main.tex
```

Dwukrotne złożenie dokumentu aktualizuje spis treści i odwołania.
