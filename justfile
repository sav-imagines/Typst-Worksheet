watch:
  typst watch example.typ

build:
  typst compile example.typ

build-png:
  typst compile example.typ --format png

[linux]
publish-local:
  cp * ~/.local/share/typst/packages/local/language_worksheet/0.0.1/
