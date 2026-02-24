set windows-shell := ["cmd.exe", "/c"]

[parallel]
watch: watch-example watch-publish-local

[parallel]
build: publish-local build-example

build-example:
  typst compile examples/example.typ

watch-example:
  typst watch examples/example.typ

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
