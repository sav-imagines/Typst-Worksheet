#import "@local/language_worksheet:0.0.1" as ws
#import "@preview/suiji:0.5.1": gen-rng
#import "@preview/catppuccin:1.1.0": catppuccin, frappe, latte, mocha, set-code-theme

#set text(size: 8pt, font: "Atkinson Hyperlegible")

#let state = (
  theme: frappe,
  rng: gen-rng(0),
)

#show: catppuccin.with(state.theme)
#set page(columns: 2, margin: 4em)

#let link-color = state.theme.colors.blue.rgb
#show link: underline.with(stroke: link-color)
#show link: text.with(fill: link-color)

#let state = ws.worksheet(..state)

#let tsv(path) = csv(path, delimiter: "	")

#let tp(body) = {
  set text(font: "Fairfax Pona HD")
  body
}

= Worksheet example
#ws.text_block(state)[
  == Introduction
  This is a small library for making good-looking, simple worksheets for teaching.

  Right now, it is focused mostly on teaching languages, but I am planning to expand into other types of class, like math and sciences.

  It features these components:

  - Text block (like this one)
  - Word order exercise
  - Conjugation tables
  - Conjugation exercise
  - Word list (including a variant with symbols)
  - Notice/warning
  - Quiz (including multiple choice variant)

  This library is focused highly on being simple to work with, and makes it easy to store data outside your code.

  It uses #link("https://catppuccin.com")[Catppuccin] to allow for simple theming of responses.
]

#ws.word_order_exercise(tsv("data/sentences.tsv"), state)
#ws.fill_conjugation_exercise(tsv("data/conjugation.tsv"), state)
#ws.conjugation_table(tsv("data/hebben.tsv"), state, "hebben")
#colbreak()
#ws.word_list(tsv("data/words.tsv"), state)
#ws.notice(state)[Note][There is an alternative word list for teaching a new alphabet:]
#ws.word_symbol_list(tsv("data/words_tok.tsv").map(x => (x.at(0), tp(x.at(0)), x.at(1))), state)
#ws.quiz(state, [Translate these sentences], tsv("./data/open_quiz.tsv").map(x => (x.at(0), none)))

#let math_questions = tsv("data/multi_choice_quiz.tsv").map(x => (eval(x.at(0), mode: "math"), ..x.slice(1)))
#ws.multi_choice_quiz(state, [Choose the right answer], math_questions)
