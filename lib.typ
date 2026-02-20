// Copyright (C) 2026 Savannah van der Kolk

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

#import "@preview/suiji:0.5.1": gen-rng, shuffle
#import "@preview/catppuccin:1.1.0": frappe
#import "@preview/linguify:0.5.0": linguify

#let lang-db = toml("lang.toml")

#let rounded_block(theme, color, body, ..others) = {
  block(
    fill: theme.colors.surface0.rgb,
    inset: 1em,
    width: 95%,
    radius: 1em,
    stroke: color + 0.2em,
    ..others,
    body,
  )
}

#let worksheet(theme: frappe, rng: gen-rng(0), ignored_characters: "?.!", numbering: numbering("1.")) = {
  return (theme: theme, rng: rng, ignored_characters: ignored_characters)
}

#let textbox(state) = {
  let colors = state.theme.colors
  box(radius: 0.2em, width: 100%, height: 1.5em)[
    #line(start: (0%, 80%), end: (100%, 80%), stroke: (
      paint: colors.rosewater.rgb,
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
  let colors = state.theme.colors
  block(above: 1.5em, width: 100%, breakable: false)[
    *#(i + 1).* [#verb]
    #linebreak()
    #for word in words {
      if word == "_" {
        h(0.2em)
        box(stroke: state.theme.colors.rosewater.rgb, radius: 0.2em)[
          #line(length: 5em, stroke: (
            dash: "loosely-dotted",
            paint: colors.text.rgb,
          ))
        ]
        h(.3em)
      } else {
        word
      }
      h(.3em)
    }
    #h(1fr)
  ]
}

#let word_order_exercise(sentences, state) = {
  let colors = state.theme.colors
  let rng = state.rng
  let shuffled_sentences = ()
  for (i, (sentence, translation)) in sentences.enumerate() {
    sentence = lower(sentence)
    for character in state.ignored_characters {
      sentence = sentence.trim(character)
    }
    let words = none
    (rng, words) = shuffle(rng, sentence.split())
    shuffled_sentences.push((words, translation))
  }
  rounded_block(
    state.theme,
    colors.rosewater.rgb,
  )[
    #linguify("word-order", from: lang-db)
    #stack(
      spacing: 0.5em,
      ..shuffled_sentences
        .enumerate()
        .map(item => {
          let (i, (words, translation)) = item
          sentence_block(i, words, translation, state)
        }),
    )
  ]
}

#let fill_conjugation_exercise(sentences, state) = {
  let colors = state.theme.colors
  rounded_block(
    state.theme,
    colors.peach.rgb,
  )[
    #linguify("add-remaining-verb", from: lang-db)
    #for (i, (sentence, verb)) in sentences.enumerate() {
      let required_character = "_" // to mitigate a weird LSP cursive rendering bug: _
      assert(sentence.contains(required_character))
      conjugation_block(i, sentence.split(), verb, state)
    }
  ]
}

#let conjugation_table(words, state, root) = {
  let colors = state.theme.colors
  let stroke = colors.maroon.rgb + 0.2em
  show table.cell.where(y: 0): strong

  rounded_block(
    state.theme,
    colors.maroon.rgb,
    inset: 0.2em,
    breakable: false,
    clip: true,
  )[
    #pad(top: .8em, left: .8em, block(above: 1.5em, width: 100%, breakable: false, [ == #linguify(
      "conjugation",
      from: lang-db,
    ) '#root']))
    #table(
      columns: (auto, 1fr),
      stroke: (x, y) => (left: if x > 0 { stroke }, top: stroke),
      table.header[Vorm][Vervoeging],
      ..(words.flatten().map(x => eval(x, mode: "markup"))),
    )
  ]
}

#let word_list(words, state) = {
  let colors = state.theme.colors
  let stroke = colors.flamingo.rgb + 0.2em
  show table.cell.where(y: 0): strong

  rounded_block(
    state.theme,
    colors.flamingo.rgb,
    inset: 0.2em,
    clip: true,
  )[
    #pad(top: .8em, left: .8em, block(above: 1.5em, width: 100%, breakable: false, [ == #linguify(
      "word-list",
      from: lang-db,
    )]))
    #table(
      columns: (auto, 1fr),
      stroke: (x, y) => (left: if x > 0 { stroke }, top: stroke),
      table.header(linguify("word", from: lang-db), linguify("meaning", from: lang-db)),
      ..words.flatten(),
    )
  ]
}

#let text_block(state, body) = {
  let colors = state.theme.colors
  let stroke = colors.lavender.rgb + 0.2em
  rounded_block(
    state.theme,
    colors.lavender.rgb,
    inset: 1em,
    body,
  )
}

#let notice(state, body) = {
  let colors = state.theme.colors
  box(
    fill: state.theme.colors.yellow.rgb.transparentize(60%),
    inset: 1em,
    radius: 1em,
    stroke: 2pt + state.theme.colors.yellow.rgb,
  )[
    #circle(radius: 0.6em, fill: blue.lighten(10%), inset: 0.1em, align(center, text(fill: white.darken(5%), [i])))
    #body
  ]
}

#let translation_exercise(state, sentences) = {
  let colors = state.theme.colors
}
