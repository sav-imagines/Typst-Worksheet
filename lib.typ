#import "@preview/suiji:0.5.1": gen-rng, shuffle
#import "@preview/catppuccin:1.1.0": frappe

#let worksheet(theme: frappe, rng: gen-rng(0), ignored_characters: "?.!", numbering: numbering("1.")) = {
  return (theme: theme, rng: rng, ignored_characters: ignored_characters)
}

#let textbox(state) = {
  box(radius: 0.2em, width: 100%, height: 2em)[
    #line(start: (0%, 80%), end: (100%, 80%), stroke: (
      paint: state.theme.colors.rosewater.rgb,
    ))
  ]
}

#let sentence_block(i, words, translation, state) = {
  block(above: 1.5em, width: 100%, breakable: false)[
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

#let conjugation_block(i, words, verb, state) = {
  block(above: 1.5em, width: 100%, breakable: false)[
    *#(i + 1).* [#verb]
    #linebreak()
    #for word in words {
      if word == "_" {
        h(0.2em)
        box(stroke: state.theme.colors.rosewater.rgb, radius: 0.2em)[
          #line(length: 5em, stroke: (
            dash: "loosely-dotted",
            paint: state.theme.colors.text.rgb,
          ))
        ]
        h(.3em)
      } else {
        word
      }
      h(.3em)
    }
    #h(1fr)
    // #verb
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
        state = (..state, rng: rng)
        sentence_block(i, words, translation, state)
      }
    ],
  )
}

#let fill_conjugation_exercise(sentences, state) = {
  block(
    fill: state.theme.colors.surface0.rgb,
    inset: 1em,
    width: 95%,
    radius: 1em,
    stroke: state.theme.colors.peach.rgb + 0.2em,
  )[
    *Vul het ontbrekende werkwoord in.*
    #for (i, (sentence, verb)) in sentences.enumerate() {
      assert(sentence.contains("_"))
      conjugation_block(i, sentence.split(), verb, state)
    }
  ]
}

#let conjugation-table(words, state) = {
  let stroke = state.theme.colors.maroon.rgb + 0.2em

  show table.cell.where(y: 0): strong
  set table(stroke: (x, y) => (
    left: if x > 0 { stroke },
    top: if y > 0 { stroke },
  ))

  block(
    fill: state.theme.colors.surface0.rgb,
    inset: 0.2em,
    width: 95%,
    radius: 1em,
    stroke: stroke,
  )[
    #pad(top: .8em, left: .8em, block(above: 1.5em, width: 100%, breakable: false, [*Vervoeging 'hebben'*]))
    #table(
      align: (right, left),
      columns: (auto, 1fr),
      stroke: (x, y) => (
        left: if x > 0 { stroke },
        top: stroke,
      ),
      [Vorm], [Vervoeging],
      ..(words.flatten()),
    )
  ]
}
