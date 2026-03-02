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
  mkdir -p ~/.local/share/typst/packages/local/language_worksheet/0.0.1/
  cp *.t* ~/.local/share/typst/packages/local/language_worksheet/0.0.1/

[windows]
publish-local:
  xcopy *.toml %APPDATA%\typst\packages\local\language_worksheet\0.0.1 /Y
  xcopy *.typ %APPDATA%\typst\packages\local\language_worksheet\0.0.1 /Y

[linux]
watch-publish-local:
  mkdir -p ~/.local/share/typst/packages/local/language_worksheet/0.0.1/
  watchexec cp *.t* ~/.local/share/typst/packages/local/language_worksheet/0.0.1/

[windows]
watch-publish-local:
  watchexec xcopy *.t* %APPDATA%\typst\packages\local\language_worksheet\0.0.1 /Y
