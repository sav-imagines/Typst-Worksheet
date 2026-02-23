set windows-shell := ["cmd.exe", "/c"]

watch:
  typst watch examples/example.typ

build:
  typst compile examples/example.typ

build-png:
  typst compile examples/example.typ --format png

[linux]
publish-local:
  cp * ~/.local/share/typst/packages/local/language_worksheet/0.0.1/

[windows]
publish-local:
  xcopy * %APPDATA%\typst\packages\local\language_worksheet\0.0.1 /Y

[linux]
watch-publish-local:
  watchexec cp * ~/.local/share/typst/packages/local/language_worksheet/0.0.1/

[windows]
watch-publish-local:
  watchexec xcopy * %APPDATA%\typst\packages\local\language_worksheet\0.0.1 /Y
