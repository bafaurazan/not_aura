# not_aura

Repozytorium projektu inżynierskiego łączy dwie części:

- kod i konfigurację systemu technicznego,
- dokumentację pracy inżynierskiej w LaTeX-u.

## Struktura

```text
not_aura/
├── docs/
│   ├── literature-review/  # osobny wykaz literatury dla promotora
│   └── thesis/             # źródła pracy inżynierskiej
└── README.md
```

Dokument główny pracy znajduje się w [`docs/thesis/main.tex`](docs/thesis/main.tex). Szczegółowy opis katalogów i polecenia budowania są dostępne w [`docs/thesis/README.md`](docs/thesis/README.md).

Opis wykorzystanej literatury dla promotora jest niezależnym dokumentem LaTeX: [`docs/literature-review/literatura.tex`](docs/literature-review/literatura.tex). Nie jest on dołączany do pracy inżynierskiej.

Część techniczna może być rozwijana w osobnych katalogach najwyższego poziomu (np. `src/`, `config/`, `tests/`) bez mieszania jej z materiałami pracy.
