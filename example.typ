#import "worksheet.typ": word_order_exercise, worksheet
#import "@preview/suiji:0.5.1": gen-rng
#import "@preview/catppuccin:1.1.0": catppuccin, frappe, mocha, set-code-theme

#let state = (
  theme: frappe,
  rng: gen-rng(0),
)
#show: catppuccin.with(state.theme)
#set page(columns: 2)

#let theme = state.theme
#let new_state = worksheet(..state)

= Werkblad Nederlands 1
#word_order_exercise(csv("sentences.tsv", delimiter: "	"), new_state)
