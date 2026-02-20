#import "@local/language_worksheet:0.0.1": (
  conjugation_table, fill_conjugation_exercise, notice, text_block, word_list, word_order_exercise, worksheet,
)
#import "@preview/suiji:0.5.1": gen-rng
#import "@preview/catppuccin:1.1.0": catppuccin, frappe, latte, mocha, set-code-theme


#let state = (
  theme: frappe,
  rng: gen-rng(0),
)
#show: catppuccin.with(state.theme)
#set page(columns: 2, margin: 4em)

#let new_state = worksheet(..state)

#let tsv(path) = csv(path, delimiter: "	")

= Werkblad Nederlands

#set text(lang: "nl")
#word_order_exercise(tsv("data/sentences.tsv"), new_state)
#fill_conjugation_exercise(tsv("data/conjugation.tsv"), new_state)
#conjugation_table(tsv("data/hebben.tsv"), new_state, "hebben")
#colbreak()
#word_list(tsv("data/words.tsv"), worksheet())
#let story = [
  == Lorem ipsum
  #lorem(25)
]
#text_block(new_state, story)
