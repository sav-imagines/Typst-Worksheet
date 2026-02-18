watch:
  typst watch example.typ

build:
  typst compile example.typ

build-png:
  typst compile example.typ --format png

[linux]
publish-local:
  cp * ~/.local/share/typst/packages/local/language_worksheet/0.0.1/

set windows-shell := ["cmd.exe", "/c"]
[windows]
publish-local:
  xcopy * %APPDATA%\typst\packages\local\language_worksheet\0.0.1 /Y
