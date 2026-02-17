#import "@preview/suiji:0.5.1": gen-rng, shuffle
#import "@preview/catppuccin:1.1.0": frappe

#let worksheet(theme: frappe, rng: gen-rng(0), ignored_characters: "?.!", numbering: numbering("1.")) = {
  return (theme: theme, rng: rng, ignored_characters: ignored_characters)
}

#let textbox(state) = {
  box(stroke: state.theme.colors.rosewater.rgb, radius: 0.2em, width: 100%, height: 1.6em)[
    #line(start: (0%, 80%), end: (100%, 80%), stroke: (
      dash: "loosely-dotted",
      paint: state.theme.colors.text.rgb,
    ))
  ]
}

#let sentence_block(i, words, translation, state) = {
  block(above: 1.5em, width: 100%)[
    *#(i + 1).* "#translation"
    #pad(left: 0.2em, block[
      #for word in words {
        box(outset: 0.2em, inset: 0.2em, radius: 0.2em, fill: state.theme.colors.surface2.rgb, [#word])
        h(0.7em)
      }
    ])

    #textbox(state)
  ]
}

#let word_order_exercise(sentences, state) = {
  let rng = state.rng
  block(
    fill: state.theme.colors.surface0.rgb,
    inset: 1em,
    width: 95%,
    radius: 1em,
    stroke: state.theme.colors.rosewater.rgb + 0.2em,
    [
      *Zet de woorden in de juiste volgorde.*
      #for (i, (sentence, translation)) in sentences.enumerate() {
        sentence = lower(sentence)
        for character in state.ignored_characters {
          sentence = sentence.trim(character)
        }
        let (sentence, words) = shuffle(rng, sentence.split())
        sentence_block(i, words, translation, state)
      }
    ],
  )
}
