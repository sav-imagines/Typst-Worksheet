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

#let A = 20%
#let LW = .1em // line width
#let BW = 100% // block width
#let lang-db = toml("lang.toml")

#let ling(word) = linguify(word, from: lang-db)

#let rounded_block(theme, color, body, ..others) = {
  block(
    fill: theme.colors.surface0.rgb,
    inset: 1em,
    width: BW,
    radius: 1em,
    stroke: color + LW,
    ..others,
    body,
  )
}

#let worksheet(theme: frappe, rng: gen-rng(0), ignored_characters: "?.!", numbering: numbering("1.")) = {
  return (theme: theme, rng: rng, ignored_characters: ignored_characters)
}

#let textbox(state) = {
  let colors = state.theme.colors
  box(radius: LW, width: BW, height: 1.5em)[
    #line(start: (0%, 80%), end: (100%, 80%), stroke: (
      paint: colors.rosewater.rgb.desaturate(A),
    ))
  ]
}

#let sentence_block(i, words, translation, state) = {
  block(above: 1.5em, width: BW, breakable: false)[
    *#(i + 1).* "#translation"
    #pad(left: 0.2em, block[
      #for word in words {
        box(outset: LW, inset: LW, radius: LW, fill: state.theme.colors.surface2.rgb, [#word])
        h(0.7em)
      }
    ])
    #textbox(state)
  ]
}

#let conjugation_block(i, words, verb, state) = {
  let colors = state.theme.colors
  block(above: 1.5em, width: BW, breakable: false)[
    *#(i + 1).* [#verb]
    #linebreak()
    #for word in words {
      if word == "_" {
        h(0.2em)
        box(stroke: state.theme.colors.rosewater.rgb.desaturate(A), radius: 0.2em)[
          #line(length: 5em, stroke: (
            dash: "loosely-dotted",
            paint: colors.text.rgb.desaturate(A),
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
    colors.rosewater.rgb.desaturate(A),
  )[
    #ling("word-order")
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
    colors.peach.rgb.desaturate(A),
  )[
    #ling("add-remaining-verb")
    #for (i, (sentence, verb)) in sentences.enumerate() {
      let required_character = "_" // to mitigate a weird LSP cursive rendering bug: _
      assert(sentence.contains(required_character))
      conjugation_block(i, sentence.split(), verb, state)
    }
  ]
}

#let conjugation_table(words, state, root) = {
  let colors = state.theme.colors
  let stroke = colors.maroon.rgb.desaturate(A) + LW
  show table.cell.where(y: 0): strong

  rounded_block(
    state.theme,
    colors.maroon.rgb.desaturate(A),
    inset: 0.2em,
    breakable: false,
    clip: true,
  )[
    #pad(top: 1em, left: 1em, block(above: 1.5em, width: BW, breakable: false, [ == #ling(
      "conjugation",
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
  let stroke = colors.flamingo.rgb.desaturate(A) + LW
  show table.cell.where(y: 0): strong

  rounded_block(
    state.theme,
    colors.flamingo.rgb.desaturate(A),
    inset: 0.2em,
    clip: true,
  )[
    #pad(top: .8em, left: .8em, block(above: 1.5em, width: BW, breakable: false, [ == #ling("word-list")]))
    #table(
      columns: (auto, 1fr),
      stroke: (x, y) => (left: if x > 0 { stroke }, top: stroke),
      table.header(ling("word"), ling("meaning")),
      ..words.flatten(),
    )
  ]
}

#let word_symbol_list(words, state, header: table.header[#ling("word")][#ling("symbol")][#ling("meaning")]) = {
  let colors = state.theme.colors
  let color = colors.flamingo.rgb
  let stroke = color.desaturate(A) + LW

  show table.cell.where(y: 0): strong
  rounded_block(
    state.theme,
    color,
    inset: 0.2em,
    clip: true,
  )[
    #pad(top: .8em, left: .8em, block(above: 1.5em, width: BW, breakable: false, [ == #ling("word-list")]))
    #table(
      columns: 3,
      stroke: (x, y) => (left: if x > 0 { stroke }, top: stroke),
      header,
      ..words.flatten(),
    )
  ]
}

#let text_block(state, body) = {
  let colors = state.theme.colors
  rounded_block(
    state.theme,
    colors.lavender.rgb.desaturate(A),
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
    stroke: LW + state.theme.colors.yellow.rgb.desaturate(A),
  )[
    #circle(radius: 0.6em, fill: blue.lighten(10%), inset: 0.1em, align(center, text(fill: white.darken(5%), [i])))
    #body
  ]
}

#let translation_exercise(state, sentences) = {
  let colors = state.theme.colors
}

// #word_symbol_list(csv("words.tsv", delimiter: "	").map(x => (x.at(0), x.at(0).at(0), x.at(1))), worksheet())
