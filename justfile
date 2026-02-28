set windows-shell := ["cmd.exe", "/c"]

[parallel]
watch: watch-example watch-publish-local

[parallel]
build: publish-local build-example show-example

build-example:
  typst compile examples/example.typ
  typst compile examples/example.typ --format png

watch-example:
  typst watch examples/example.typ

show-example:
  typst compile examples/example.typ --format png

[linux]
publish-local:
  cp *.toml ~/.local/share/typst/packages/local/language_worksheet/0.0.1/
  cp *.typ ~/.local/share/typst/packages/local/language_worksheet/0.0.1/

[windows]
publish-local:
  xcopy * %APPDATA%\typst\packages\local\language_worksheet\0.0.1 /Y

[linux]
watch-publish-local:
  watchexec cp * ~/.local/share/typst/packages/local/language_worksheet/0.0.1/

[windows]
watch-publish-local:
  watchexec xcopy * %APPDATA%\typst\packages\local\language_worksheet\0.0.1 /Y
