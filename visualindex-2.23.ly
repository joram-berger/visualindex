% visualindex-2.23.ly
%
% This file was created by Joram Berger <joramberger.de>.
%
% Extended and completely revised by Werner Lemberg <wl@gnu.org> to
% cover more grobs.

% Currently it is not available under a free license but I am willing to
% provide it under a Creative Commons license or something compatible with
% the LilyPond documentation upon request.
%
% open issues:
%
% - Links are not clickable in SVG output


\version "2.23.6"

#(set-default-paper-size "a4")
% #(set-default-paper-size "letter")

\pointAndClickOff
#(set-global-staff-size 18)


\header {
  title = \markup \larger \larger "Visual LilyPond Grob Index"
  tagline = ##f
}

\paper {
  page-count = 1

  ragged-bottom = ##t
  ragged-last-bottom = ##t

  system-system-spacing.padding = #4

  score-markup-spacing.basic-distance = #0
  score-markup-spacing.minimum-distance = #0
  score-markup-spacing.padding = #1.5
  score-markup-spacing.stretchability = #0

  markup-system-spacing.basic-distance = #0
  markup-system-spacing.minimum-distance = #0
  markup-system-spacing.padding = #2.5
  markup-system-spacing.stretchability = #0

  markup-markup-spacing.basic-distance = #0
  markup-markup-spacing.minimum-distance = #0
  markup-markup-spacing.padding = #2
  markup-markup-spacing.stretchability = #0

  top-markup-spacing.basic-distance = #0
  top-markup-spacing.minimum-distance = #0
  top-markup-spacing.padding = #6
  top-markup-spacing.stretchability = #0

  % A font for the Vai script must be installed on your system
  % to print out a proper glyph for U+A52E (the three fonts
  % below don't contain it).
  fonts = #(make-pango-font-tree
            "Linux Libertine O"
            "Linux Biolinum O"
            "Ubuntu Mono"
            (/ (* staff-height pt) 2.5))
}


\layout {
  \context {
    \Score
    \override BalloonText.baseline-skip = #2.3
  }
  \context {
    \Staff
    \override InstrumentName.baseline-skip = #2.3
  }
  \context {
    \Voice
    \override TextScript.baseline-skip = #2.3
  }
}


% Object link funtion from Jean Abou Samra.
#(use-modules (ice-9 match))

addLink =
#(match (ly:version)
   ((major minor _)
    (define-music-function (path doc) (symbol-list? string?)
      (propertyOverride
       (append path '(stencil))
       (grob-transformer 'stencil
        (lambda (grob original)
          (if (ly:stencil? original)
              (let ((url (format #f
                                 "https://lilypond.org/doc/v~a.~a/Documentation/notation/~a"
                                 major
                                 minor
                                 doc)))
                (grob-interpret-markup
                 grob
                 (make-with-url-markup url (make-stencil-markup original))))
              original)))))))


#(define-markup-command (doclink layout props text) (string?)
   "Return a text linked to the internal reference."
   (interpret-markup layout props
     #{
       \markup \with-url
       #(string-append
         "https://lilypond.org/doc/v2.23/Documentation/internals/"
         (string-downcase text))
       \with-color #(x11-color "navy") #text
     #}))

#(define-markup-command (contextlink layout props text) (string?)
   "Return a text linked to the internal reference."
   (interpret-markup layout props
     #{
       \markup \with-url
       #(string-append
         "https://lilypond.org/doc/v2.23/Documentation/internals/"
         (string-downcase text))
       \bold \larger \with-color #(x11-color "DarkRed")
         \rounded-box #text
     #}))

#(define-markup-command (engraverlink layout props link text)
   (string? string?)
   "Return a text linked to the internal reference."
   (interpret-markup layout props
     #{
       \markup \with-url
       #(string-append
         "https://lilypond.org/doc/v2.23/Documentation/internals/"
         (string-regexp-substitute "_" "_005f" (string-downcase link))
         "_005fengraver")
       \italic \with-color #(x11-color "royal blue")
       #(if (string=? "s" text) "ꔮ" text)
     #}))


%%% Top Stuff %%%

\markup {
  \override #'(baseline-skip . 2.7)
  \fontsize #-2 \with-color #grey
  \fill-line {
    \column {
      \bold "Legend:"
      \line {
        " "
        \with-url
          "https://lilypond.org/doc/v2.23/Documentation/internals/all-layout-objects"
          { \with-color #(x11-color "navy") "GraphicalObject (Grob)" } }
      \vspace #-0.05
      \line {
        " "
        \with-url
          "https://lilypond.org/doc/v2.23/Documentation/internals/engravers-and-performers"
          { \italic \with-color #(x11-color "royal blue") "Engraver ꔮ" } }
      \vspace #0.1
      \line {
        " "
        \smaller \contextlink "Contexts" } }
    \null
    \column {
      \line { \bold "Example:" "'BarNumber ꔮ' means:" }
      "  the graphical object is called: BarNumber"
      "  suggested search terms: bar number"
      "  the engraver name (as not specified otherwise): Bar_number_engraver" }
    \null
    \null
    \null } }


%%% Score %%%

\markup {
  \vspace #1.3
  \line {
    \contextlink "Score"
    \override #'(baseline-skip . 2.3)
    \column {
      \line {
        "["
        \doclink "BreakAlignGroup"
        \doclink "BreakAlignment"
        \doclink "ControlPoint"
        \doclink "ControlPolygon"
        \doclink "GraceSpacing" }
      \line {
        \transparent "["
        \doclink "NonMusicalPaperColumn"
        \doclink "PaperColumn"
        \doclink "SpacingSpanner"
        \doclink "VerticalAlignment"
        "]" } } } }

\score {
  \new StaffGroup <<
    % `collapse-height` must be lower than the actual number of staff
    % lines.
    \override StaffGroup.SystemStartBracket.collapse-height = #1
    \override Score.SystemStartBar.collapse-height = #1

    \new Staff \with {
      \override InstrumentName.extra-offset = #'(1 . 0)
      instrumentName = \markup \column {
        \null
        \line { \doclink "SystemStartBar" "|" }
        \line { \doclink "SystemStartBrace" "{" %{ to balance braces } %} }
        \line { \doclink "SystemStartBracket" "→" }
        \line { \doclink "SystemStartSquare" "[" }
        \line { \engraverlink "System_start_delimiter"
                              "System_start_delimiter" } }
    } \relative c'' {
      \override Score.SpacingSpanner.common-shortest-duration =
         #(ly:make-moment 1/32)

      \override Score.BarNumber.break-visibility = ##(#t #t #t)
      \override Score.BalloonText.annotation-balloon = ##f

      \addLink Score.BarLine "bars#bar-lines"
      \addLink Score.BarNumber "bars#bar-numbers"
      \addLink Score.CenteredBarNumber "bars#bar-numbers"
      \addLink Score.CodaMark "XXX not yet documented"
      \addLink Score.Footnote "creating-footnotes"
      \addLink Score.JumpScript "XXX not yet documented"
      \addLink Score.MetronomeMark "displaying-rhythms#metronome-marks"
      \addLink Score.Parentheses "inside-the-staff#parentheses"
      \addLink Score.RehearsalMark "bars#rehearsal-marks"
      \addLink Score.SectionLabel "XXX not yet documented"
      \addLink Score.SegnoMark "XXX not yet documented"
      \addLink Score.SystemStartBracket "displaying-staves#grouping-staves"
      \addLink Score.VoltaBracket "long-repeats#normal-repeats"

      \addLink NoteHead "writing-pitches"

      \omit Staff.Clef
      \omit Staff.TimeSignature

      \balloonGrobText LeftEdge #'(-1 . 7) \markup \line {
        \engraverlink "Break_align" "Break_align"
        \doclink "LeftEdge" }
      \balloonGrobText MetronomeMark #'(-1 . 5) \markup \line {
        \doclink "MetronomeMark"
        \engraverlink "Metronome_mark" "s" }
      \tweak X-offset #1 \tempo Allegro
      a1

      \balloonGrobText BarNumber #'(0 . 1.5) \markup \line {
        \doclink "BarNumber"
        \engraverlink "Bar_number" "s" }
      a1

      \set Score.centerBarNumbers = ##t
      \balloonGrobText CenteredBarNumber #'(0 . 3.5) \markup \center-column {
        \doclink "CenteredBarNumberLineSpanner"
        \doclink "CenteredBarNumber" }
      \once\override Score.CenteredBarNumberLineSpanner.padding = #3
      a1
      \set Score.centerBarNumbers = ##f

      \revert Score.BarNumber.break-visibility

      \balloonGrobText RehearsalMark #'(0.1 . 1) \markup \line {
        \doclink "RehearsalMark"
        \engraverlink "Mark" "Mark" }
      \once\override Score.RehearsalMark.outside-staff-priority = ##f
      \mark \default

      \balloonGrobText Parentheses #'(-1 . -2) \markup \column {
        \doclink "Parentheses"
        \engraverlink "Parenthesis" "Parenthesis" }
      \parenthesize a1

      \repeat volta 2 {
        \once\override Score.BalloonText.extra-offset = #'(2 . -1.2)
        \balloonGrobText Footnote #'(-1 . -2) \markup \line {
          \doclink "Footnote"
          \engraverlink "Footnote" "s" }
        \override Score.Footnote.color = #red
        \once \override TextScript.Y-offset = #-6
        \footnote #'(1 . -2) \markup \fill-line {
          "Footnote"
          \with-url
          "http://www.joramberger.de"
          "© 2013–2022 Joram Berger · joramberger.de"
          \null }
        a1

        \once \override Score.BalloonText.text-alignment-X = -0.5
        \balloonGrobText VoltaBracket #'(0 . 2) \markup \column {
          \line {
            \doclink "VoltaBracket"
            \engraverlink "Volta" "Volta" }
          \doclink "VoltaBracketSpanner" }
        \alternative {
          { a1 }
          { \once\override Score.VoltaBracket.shorten-pair = #'(1 . 2)
            a1 } } }

      \repeat segno 2 {
        \balloonGrobText SegnoMark #'(1 . 2.5) \markup
          \doclink "SegnoMark"
        a1

        \balloonGrobText CodaMark #'(1 . 0.5) \markup
          \doclink "CodaMark"
        \once\override Score.CodaMark.outside-staff-priority = ##f
        \alternative {
          \volta 1 { a1 }
          \volta 2 \volta #'() {
            \section
            \once\override Score.SectionLabel.outside-staff-priority = ##f
            \balloonGrobText SectionLabel #'(0 . 5) \markup
              \doclink "SectionLabel"
            \sectionLabel "Coda" } } }

      \once \override Score.BalloonText.text-alignment-Y = 0
      \balloonGrobText JumpScript #'(-2 . -1) \markup {
        \engraverlink "Jump" "Jump"
        \doclink "JumpScript" }
      <>

      a1

      \bar "|."
    }
  >>

  \layout {
    indent = 3.5\cm

    \context {
      \Score
      \consists Balloon_engraver
      \balloonLengthOff
      % XXX Temporary work-around for issue #6240.
      \override BalloonText.after-line-breaking =
        #(lambda (grob)
           (ly:side-position-interface::move-to-extremal-staff grob)
           (ly:axis-group-interface::add-element
             (ly:grob-object (ly:grob-parent grob Y)
                             'axis-group-parent-Y)
             grob))

      dalSegnoTextFormatter = #format-dal-segno-text-brief
    }
  }
}


%%% Staff %%%

% XXX SpanBar, SpanBarStub

\markup {
  \line {
    \contextlink "Staff"

    "["
    \doclink "DotColumn"
    \doclink "LedgerLineSpanner"
    \doclink "NoteCollision"
    \doclink "RestCollision"
    \doclink "ScriptRow"
    \doclink "VerticalAxisGroup"
    "]" } }

\score {
  \new Staff \with {
    \override InstrumentName.Y-offset = #-9
    instrumentName = \markup \right-column {
      \doclink "InstrumentName"
      \engraverlink "Instrument_name" "s" }
  } \new Voice = "eins" \relative c'' {
    \override Score.SpacingSpanner.common-shortest-duration =
       #(ly:make-moment 1/5)
    \override Score.BalloonText.annotation-balloon = ##f

    \addLink Staff.BarLine "bars#bar-lines"
    \addLink Staff.Clef "displaying-pitches#clef"
    \addLink Staff.ClefModifier "displaying-pitches#clef"
    \addLink Staff.CueClef "writing-parts#formatting-cue-notes"
    \addLink Staff.CueEndClef "writing-parts#formatting-cue-notes"
    \addLink Staff.KeyCancellation "displaying-pitches#key-signature"
    \addLink Staff.KeySignature "displaying-pitches#key-signature"
    \addLink Staff.OttavaBracket "displaying-pitches#ottava-brackets"
    \addLink Staff.PianoPedalBracket "piano#piano-pedals"
    \addLink Staff.SostenutoPedal "piano#piano-pedals"
    \addLink Staff.SustainPedal "piano#piano-pedals"
    \addLink Staff.TimeSignature "displaying-rhythms#time-signature"
    \addLink Staff.UnaCordaPedal "piano#piano-pedals"

    \addLink Accidental "writing-pitches"
    \addLink AccidentalCautionary "writing-pitches"
    \addLink AccidentalSuggestion
      "typesetting-mensural-music#annotational-accidentals-_0028musica-ficta_0029"
    \addLink Dots "writing-rhythms#durations"
    \addLink NoteHead "writing-pitches"
    \addLink Rest "writing-rests#rests"

    \balloonGrobText Clef #'(-1 . -2) \markup \line {
      \doclink "Clef"
      \engraverlink "Clef" "s" }
    \balloonGrobText ClefModifier #'(1 . -1.5) \markup
      \doclink "ClefModifier"
    \clef "treble_8"

    \balloonGrobText KeySignature #'(-1 . 1) \markup \line {
      \engraverlink "Key" "Key"
      \doclink "KeySignature" }
    \time 4/4

    \balloonGrobText TimeSignature #'(-0.5 . 6) \markup \line {
      \doclink "TimeSignature"
      \engraverlink "Time_signature" "s" }
    \key g \major
    a,1

    \balloonGrobText BarLine #'(-1 . -1) \markup \line {
      \doclink "BarLine"
      \engraverlink "Bar" "Bar" }

    \balloonGrobText KeyCancellation #'(0 . 1.5) \markup
      \doclink "KeyCancellation"
    \key c \major

    \balloonGrobText Accidental #'(-3 . -6) \markup \right-column {
      \line {
        \doclink "Accidental"
        \engraverlink "Accidental" "s" }
      \doclink "AccidentalPlacement" }
    es2

    \once \override Score.BalloonText.Y-attachment = #0.5
    \balloonGrobText AccidentalCautionary #'(0.5 . 1) \markup
      \doclink "AccidentalCautionary"
    es'?2

    \once \override Score.BalloonText.text-alignment-X = 0.3
    \balloonGrobText SostenutoPedal #'(0 . -1) \markup \center-column {
      \doclink "SostenutoPedal"
      \doclink "SostenutoPedalLineSpanner" }
    a,1\tweak X-offset #-2 \sostenutoOn
    \after 2. \sostenutoOff a1

    \balloonGrobText UnaCordaPedal #'(0 . -4) \markup \center-column {
      \doclink "UnaCordaPedal"
      \doclink "UnaCordaPedalLineSpanner" }
    \balloonGrobText AccidentalSuggestion #'(-1 . 2.5) \markup
      \doclink "AccidentalSuggestion"
    \set suggestAccidentals = ##t
    ais1\tweak X-offset #0.5 \unaCorda
    \set suggestAccidentals = ##f

    \balloonGrobText OttavaBracket #'(0 . 1) \markup \column {
      \engraverlink "Ottava_spanner" "Ottava_spanner"
      \doclink "OttavaBracket" }
    \ottava #1
    a'1
    \ottava #0

    \balloonGrobText SustainPedal #'(1 . -2.5) \markup \column {
      \doclink "SustainPedal"
      \doclink "SustainPedalLineSpanner" }
    a,2\tweak X-offset #0 \sustainOn
    \after 4\sustainOff a2

    \balloonGrobText CueClef #'(1 . 5) \markup \column {
      \line {
        \doclink "CueClef"
        \engraverlink "Cue_clef" "s" } }
    \cueClef "bass"
    \new CueVoice { b,1 }

    \balloonGrobText CueEndClef #'(1 . 2) \markup
      \doclink "CueEndClef"
    \cueClefUnset

    \set Staff.pedalSustainStyle = #'bracket

    \balloonGrobText PianoPedalBracket #'(1 . -1) \markup \column {
      \doclink "PianoPedalBracket"
      \engraverlink "Piano_pedal" "Piano_pedal" }
    a'2 \sustainOn
    a2 \sustainOff

    \tweak X-offset #1.5 \tweak Y-offset #0.5 \mark \markup {
      \normalsize
      \column {
        \doclink "StaffSymbol"
        \doclink "StaffSpacing" } }

    \bar "|."
  }

  \layout {
    indent = 2.3\cm

    \context {
      \Score
      \consists Balloon_engraver
      \balloonLengthOff
      % XXX Temporary work-around for issue #6240.
      \override BalloonText.after-line-breaking =
        #(lambda (grob)
           (ly:side-position-interface::move-to-extremal-staff grob)
           (ly:axis-group-interface::add-element
             (ly:grob-object (ly:grob-parent grob Y)
                             'axis-group-parent-Y)
             grob))
    }
  }
}


%%% Voice %%%

% XXX StemStub, VoiceFollower

% The `InstrumentSwitch` grob is obsolete.

\markup {
  \line {
    \contextlink "Voice"
    \override #'(baseline-skip . 2.3)
    \column {
      \line {
        "["
        \doclink "CombineTextScript"
        \doclink "FingeringColumn"
        \doclink "LaissezVibrerTieColumn"
        \doclink "NoteColumn"
        \doclink "NoteSpacing" }
      \line {
        \transparent "["
        \doclink "RepeatTieColumn"
        \doclink "ScriptColumn"
        \doclink "TieColumn"
        "]" } } } }

\score {
  \new Voice = "eins" \relative c' {
    \override Score.BalloonText.annotation-balloon = ##f

    \addLink Staff.BarLine "bars#bar-lines"

    \addLink Arpeggio "expressive-marks-as-lines#arpeggio"
    \addLink Beam "beams"
    \addLink BendAfter "expressive-marks-as-curves#falls-and-doits"
    \addLink BreathingSign "expressive-marks-as-curves#breath-marks"
    \addLink ClusterSpanner "single-voice#clusters"
    \addLink Dots "writing-rhythms#durations"
    \addLink DoublePercentRepeat "short-repeats#percent-repeats"
    \addLink DoublePercentRepeatCounter "short-repeats#percent-repeats"
    \addLink DoubleRepeatSlash "short-repeats#percent-repeats"
    \addLink DynamicText "expressive-marks-attached-to-notes#dynamics"
    \addLink DynamicTextSpanner "expressive-marks-attached-to-notes#dynamics"
    \addLink FingerGlideSpanner "inside-the-staff#gliding-fingers"
    \addLink Fingering "inside-the-staff#fingering-instructions"
    \addLink Flag "writing-rhythms#durations"
    \addLink Glissando "expressive-marks-as-lines#glissando"
    \addLink Hairpin "expressive-marks-attached-to-notes#dynamics"
    \addLink LaissezVibrerTie "writing-rhythms#ties"
    \addLink LigatureBracket
      "ancient-notation_002d_002dcommon-features#ligatures"
    \addLink MultiMeasureRest "writing-rests#full-measure-rests"
    \addLink MultiMeasureRestNumber "writing-rests#full-measure-rests"
    \addLink MultiMeasureRestScript "writing-rests#full-measure-rests"
    \addLink MultiMeasureRestText "writing-rests#full-measure-rests"
    \addLink NoteHead "writing-pitches"
    \addLink PercentRepeat "short-repeats#percent-repeats"
    \addLink PercentRepeatCounter "short-repeats#percent-repeats"
    \addLink PhrasingSlur "expressive-marks-as-curves#phrasing-slurs"
    \addLink RepeatSlash "short-repeats#percent-repeats"
    \addLink RepeatTie "writing-rhythms#ties"
    \addLink Rest "writing-rests#rests"
    \addLink Script "expressive-marks-attached-to-notes"
    \addLink Slur "expressive-marks-as-curves#slurs"
    \addLink StemTremolo "short-repeats#tremolo-repeats"
    \addLink StringNumber
      "common-notation-for-fretted-strings#string-number-indications"
    \addLink TextSpanner "writing-text.html#text-spanners"
    \addLink Tie "writing-rhythms#ties"
    \addLink TrillPitchAccidental "expressive-marks-as-lines#trills"
    \addLink TrillPitchHead "expressive-marks-as-lines#trills"
    \addLink TrillPitchParentheses "expressive-marks-as-lines#trills"
    \addLink TrillSpanner "expressive-marks-as-lines#trills"
    \addLink TupletBracket "writing-rhythms#tuplets"
    \addLink TupletNumber "writing-rhythms#tuplets"

    \omit Staff.Clef
    \omit Staff.TimeSignature
    \omit Score.BarNumber

    \set countPercentRepeats = ##t

    \after 1 {
      \newSpacingSection
      \override Score.SpacingSpanner.spacing-increment = #1 }
    \repeat percent 2 {
      \once \override Score.BalloonText.text-alignment-X = -0.3
      \balloonGrobText NoteHead #'(0.5 . -2) \markup \line {
        \doclink "NoteHead"
        \engraverlink "Note_head" "s" }
      \balloonGrobText Stem #'(1.5 . 4.5) \markup \line {
        \doclink "Stem"
        \engraverlink "Stem" "s" }
      d2

      \balloonGrobText Rest #'(1 . 1.5) \markup \line {
        \doclink "Rest"
        \engraverlink "Rest" "s" }
      r4

      \after 8 {
        \once \override Score.BalloonText.X-attachment = #CENTER
        \once \override Score.BalloonText.text-alignment-X = 0.3
        \balloonGrobText RepeatSlash #'(-2 . -4) \markup \column {
          \doclink "RepeatSlash"
          \engraverlink "Slash_repeat" "Slash_repeat" } }
      \repeat percent 2 {
        d32[ e f g] }

      \once \override Score.BalloonText.text-alignment-X = 0.1
      \balloonGrobText PercentRepeat #'(1.5 . -2) \markup \line {
        \doclink "PercentRepeat"
        \engraverlink "Percent_repeat" "s" }
      \balloonGrobText PercentRepeatCounter #'(-1 . 3.5) \markup
        \doclink "PercentRepeatCounter" }

    \newSpacingSection
    \revert Score.SpacingSpanner.spacing-increment

    % The correct time offset to access the `DoublePercentRepeat` grob
    % is the beginning of the second bar.
    \after 1*3 {
      \balloonGrobText DoublePercentRepeat #'(-1 . -5) \markup \line {
        \doclink "DoublePercentRepeat"
        \engraverlink "Double_percent_repeat" "s" }
      \balloonGrobText DoublePercentRepeatCounter #'(0 . 2) \markup
        \doclink "DoublePercentRepeatCounter"
      \newSpacingSection
    }

    \repeat percent 2 {
      \balloonGrobText Flag #'(0 . 1) \markup
        \doclink "Flag"
      g8\noBeam

      \balloonGrobText StemTremolo #'(1 . -3.5) \markup
        \doclink "StemTremolo"
      g4:16

      \balloonGrobText Beam #'(0 . 4) \markup \center-column {
        \engraverlink "Auto_beam" "Auto_beam"
        \line {
          \doclink "Beam"
          \engraverlink "Beam" "s" } }
      g16[ g]

      \after 8 {
        \once \override Score.BalloonText.X-attachment = #CENTER
        \balloonGrobText DoubleRepeatSlash #'(-2 . -5) \markup
          \doclink "DoubleRepeatSlash" }
      \repeat percent 2 {
        \balloonGrobText Dots #'(0 . 2) \markup \line {
          \doclink "Dots"
          \engraverlink "Dots" "s" }
        e'16. e32 }

      \balloonGrobText Script #'(0 . 2) \markup \line {
        \doclink "Script"
        \engraverlink "Script" "s" }
      c8-> a8

      \balloonGrobText Fingering #'(-1 . 2) \markup \line {
        \doclink "Fingering"
        \engraverlink "Fingering" "s" }
      \balloonGrobText StringNumber #'(0.5 . 1.5) \markup \column {
        \doclink "StringNumber"
        \engraverlink "New_fingering" "New_fingering" }
      \balloonGrobText StrokeFinger #'(-1 . -2) \markup
        \doclink "StrokeFinger"
      g4\2-1\rightHandFinger #1

      \balloonGrobText Arpeggio #'(-1 . -4.5) \markup \line {
        \doclink "Arpeggio"
        \engraverlink "Arpeggio" "s" }
      <e g b e>4\arpeggio

      \once\override Score.BalloonText.extra-offset = #'(0 . 1.5)
      \balloonGrobText Glissando #'(0 . -3) \markup \line {
        \doclink "Glissando"
        \engraverlink "Glissando" "s" }
      \once\override Score.TextScript.X-offset = #-3.5
      e'4:16\tweak springs-and-rods #ly:spanner::set-spacing-rods
        \tweak minimum-length #8 \glissando
      e,4

      \balloonGrobText BreathingSign #'(0 . 1) \markup \line {
        \doclink "BreathingSign"
        \engraverlink "Breathing_sign" "s" }
      \breathe }

    \balloonGrobText TextSpanner #'(0 . -1) \markup \line {
      \doclink "TextSpanner"
      \engraverlink "Text_spanner" "s" }
    \once\override TextSpanner.bound-details.left.text = "rit."
    \once\override TextSpanner.outside-staff-priority = ##f
    \once\override TextSpanner.padding = #0.4
    \textSpannerDown
    a4\startTextSpan a a a\stopTextSpan

    \override Staff.MultiMeasureRest.space-increment = #1
    \compressMMRests {
      \balloonGrobText MultiMeasureRest #'(-1 . -6.5) \markup \line {
        \doclink "MultiMeasureRest"
        \engraverlink "Multi_measure_rest" "s" }
      \balloonGrobText MultiMeasureRestNumber #'(-1 . 4.5) \markup
        \doclink "MultiMeasureRestNumber"
      R1*4 }

    \break

    \once \override Score.BalloonText.X-attachment = #CENTER
    \balloonGrobText MultiMeasureRestScript #'(0.5 . 6.5) \markup
      \doclink "MultiMeasureRestScript"
    \balloonGrobText MultiMeasureRestText #'(1 . -5) \markup
      \doclink "MultiMeasureRestText"
    R1\fermata_\markup \italic "lunga"

    \bar "||"

    \balloonGrobText DynamicTextSpanner #'(0 . -1.5) \markup
      \doclink "DynamicTextSpanner"
    \balloonGrobText TextScript #'(0 . 3.5) \markup \line {
      \doclink "TextScript"
      \engraverlink "Text" "Text" }
    \once\override TextScript.outside-staff-priority = ##f
    c4^\markup {
      \with-url
        "https://lilypond.org/doc/v2.23/Documentation/notation/writing-text"
      \italic "dolce" }
      \cresc
    c4

    \once\override Score.BalloonText.extra-offset = #'(0.5 . -1)
    \balloonGrobText FingerGlideSpanner #'(0 . 3) \markup \center-column {
      \doclink "FingerGlideSpanner"
      \engraverlink "Finger_glide" "Finger_glide" }
    \set fingeringOrientations = #'(right)
    <c\glide-1>4
    \set fingeringOrientations = #'(left)
    <g-1>4

    \balloonGrobText DynamicText #'(1 . -5) \markup \line {
      \doclink "DynamicText"
      \engraverlink "Dynamic" "Dynamic" }
    c\ff

    \once \override Score.BalloonText.X-attachment = #CENTER
    \balloonGrobText Hairpin #'(0.1 . -1) \markup \column {
      \doclink "Hairpin"
      \doclink "DynamicLineSpanner" }
    c4\> <>\!

    \balloonGrobText TrillSpanner #'(-1 . 3) \markup \line {
      \doclink "TrillSpanner"
      \engraverlink "Trill_spanner" "s" }
    \balloonGrobText TrillPitchParentheses #'(1.5 . 2.5) \markup \column {
      \line {
        \doclink "TrillPitchGroup"
        \engraverlink "Pitched_trill" "Pitched_trill" }
      \doclink "TrillPitchAccidental"
      \doclink "TrillPitchHead"
      \doclink "TrillPitchParentheses" }
    \pitchedTrill
    c4 \startTrillSpan des r\stopTrillSpan

    \bar "||"

    \balloonGrobText Slur #'(0 . -1) \markup \line {
      \doclink "Slur"
      \engraverlink "Slur" "s" }
    a4( g4)

    \once \override Score.BalloonText.X-attachment = 0.3
    \balloonGrobText PhrasingSlur #'(0 . 1.5) \markup \line {
      \doclink "PhrasingSlur"
      \engraverlink "Phrasing_slur" "s" }
    c\(

    \balloonGrobText Tie #'(0 . -1) \markup \line {
      \doclink "Tie"
      \engraverlink "Tie" "s" }
    g4 ~ g

    \balloonGrobText RepeatTie #'(-2 . -3) \markup \line {
      \doclink "RepeatTie"
      \engraverlink "Repeat_tie" "s" }
    e\repeatTie

    \balloonGrobText LaissezVibrerTie #'(0 . -2) \markup \column {
      \doclink "LaissezVibrerTie"
      \engraverlink "Laissez_vibrer" "Laissez_vibrer" }
    e\laissezVibrer

    \once \override Score.BalloonText.X-attachment = #CENTER
    \balloonGrobText BendAfter #'(0.1 . 2.5) \markup \column {
      \engraverlink "Bend" "Bend"
      \doclink "BendAfter" }
    e'\)\bendAfter #-6

    \bar "||"

    \balloonGrobText TupletNumber #'(1 . -3) \markup
      \doclink "TupletNumber"
    \balloonGrobText TupletBracket #'(1 . -0.5) \markup \line {
      \doclink "TupletBracket"
      \engraverlink "Tuplet" "Tuplet" }
    \tuplet 3/2 { d4 c b }

    \balloonGrobText LigatureBracket #'(-1 . 5) \markup \line {
      \doclink "LigatureBracket"
      \engraverlink "Ligature_bracket" "s" }
    \once\override LigatureBracket.padding = #1
    \[ c4 b \]

    \once \override Score.BalloonText.X-attachment = #-0.5
    \balloonGrobText ClusterSpanner #'(0 . 3) \markup \column {
      \line {
        \doclink "ClusterSpanner"
        \engraverlink "Cluster_spanner" "s" }
      \doclink "ClusterSpannerBeacon" }
    \makeClusters { <c e>4  <b f'> <b g'> <c g> }

    \bar "|."
  }

  \layout {
    indent = 0

    \context {
      \Score
      \consists Balloon_engraver
      \balloonLengthOff
      % XXX Temporary work-around for issue #6240.
      \override BalloonText.after-line-breaking =
        #(lambda (grob)
           (ly:side-position-interface::move-to-extremal-staff grob)
           (ly:axis-group-interface::add-element
             (ly:grob-object (ly:grob-parent grob Y)
                             'axis-group-parent-Y)
             grob))
    }
  }
}


%%% ChordNames, FiguredBass, Lyrics %%%

\markup \with-dimensions #'(0 . 0) #'(0 . 0) {
  \column {
    \vspace #1.5
    \contextlink "ChordNames"
    \vspace #0.5
    \line {
      \contextlink "FiguredBass"
      \engraverlink "Figured_bass" "s" }
    \vspace #2
    \contextlink "Lyrics" } }

\score {
  <<
    \new ChordNames \chordmode {
      \addLink ChordName "displaying-chords"

      \balloonGrobText ChordName #'(1 . 1) \markup {
        \doclink "ChordName"
        \engraverlink "Chord_name" "s" }
      f1 c1 f1
    }

    \new Staff \with {
      \override InstrumentName.X-offset = #-32
      \override InstrumentName.Y-offset = #-7
      instrumentName = \markup \column {
        \doclink "BassFigureAlignment"
        \doclink "BassFigureAlignmentPositioning"
        \vspace #1.7
        \doclink "LyricSpace" }

    } \new Voice = "voice" \relative c' {
      \override Score.SpacingSpanner.common-shortest-duration =
         #(ly:make-moment 1/64)
      \override Score.BalloonText.annotation-balloon = ##f

      \addLink NoteHead "writing-pitches"
      \addLink Slur "expressive-marks-as-curves#slurs"

      \omit Staff.BarLine
      \omit Staff.Clef
      \omit Staff.TimeSignature

      f4 g a( bes) c d e f
      f2 f
      \bar"|."
    }

    \new FiguredBass \with {
      \override VerticalAxisGroup.nonstaff-nonstaff-spacing.padding = #2
    } \figuremode {
      \addLink BassFigure "figured-bass"
      \addLink BassFigureContinuation "figured-bass"
      \addLink BassFigureBracket "figured-bass"

      \bassFigureExtendersOn

      \balloonGrobText BassFigure #'(1 . -2) \markup
        \doclink "BassFigure"
      <5>2

      \balloonGrobText BassFigureBracket #'(1 . -2) \markup
        \doclink "BassFigureBracket"
      <[6]>2

      % XXX Temporary work-around for issue #6240.
      \once \override Score.BalloonText.text-alignment-Y = #0
      \balloonGrobText BassFigureLine #'(2 . -1.5) \markup \column {
        \doclink "BassFigureLine"
        \doclink "BassFigureContinuation" }
      <5>2 <5>
    }

    \new Lyrics \with {
      \override LyricText.Y-extent = #'(-0.5 . 3.5)

      \addLink LyricText
        "common-notation-for-vocal-music#aligning-lyrics-to-a-melody"
      \addLink StanzaNumber "stanzas#adding-stanza-numbers"
      \addLink VowelTransition
        "common-notation-for-vocal-music#gradual-changes-of-vowel"
    } \lyricsto "voice" {
      \balloonGrobText StanzaNumber #'(1 . -3) \markup \line {
        \doclink "StanzaNumber"
        \engraverlink "Stanza_number" "s" }
      \set stanza = "1."

      Lo -- rem ip -- sum

      \balloonGrobText LyricText #'(0 . -1.5) \markup \column {
        \doclink "LyricText"
        \engraverlink "Lyric" "Lyric" }
      do --
      \balloonGrobText LyricExtender #'(0 . -4.5) \markup \column {
        \doclink "LyricExtender"
        \engraverlink "Extender" "Extender" }
      lor __

      \balloonGrobText VowelTransition #'(0 . -1.5) \markup
        \doclink "VowelTransition"
      sit

      \vowelTransition

      \balloonGrobText LyricHyphen #'(4 . -2) \markup \column {
        \doclink "LyricHyphen"
        \engraverlink "Hyphen" "Hyphen" }
      a -- met.
    }
  >>

  \layout {
    indent = 5.5\cm

    \context {
      \Score
      \consists Balloon_engraver
      \balloonLengthOff
      % XXX Temporary work-around for issue #6240.
      \override BalloonText.after-line-breaking =
        #(lambda (grob)
           (let* ((host (ly:grob-object grob 'sticky-host))
                  (group (ly:grob-object host 'axis-group-parent-Y)))
             (ly:axis-group-interface::add-element
              (if (grob::has-interface group 'align-interface)
                  (ly:grob-parent group Y)
                  group)
              grob)))
    }
  }
}


%
% XXX TO BE DONE
%


%%% TabVoice %%%

% BendSpanner, TabNoteHead


%%% MensuralStaff, MensuralVoice, PetrucciStaff, PetrucciVoice, %%%
%%% VaticanaStaff %%%

% Custos, Episema, MensuralLigature, VaticanaLigature


%%% KievanVoice %%%

% KievanLigature


%%% FretBoard %%%

% FretBoard


%%% NoteNames %%%

% NoteName


%%% extra stuff, not part of any context by default %%%

% System

% Ambitus, AmbitusAccidental, AmbitusLine, AmbitusNoteHead,
% BalloonText, DurationLine, GridLine, GridPoint, HorizontalBracket,
% HorizontalBracketText, MeasureCounter, MeasureGrouping,
% MeasureSpanner, MelodyItem

% \addLink Staff.AmbitusAccidental "displaying-pitches#ambitus"
% \addLink Staff.AmbitusLine "displaying-pitches#ambitus"
% \addLink Staff.AmbitusNoteHead "displaying-pitches#ambitus"

% \balloonGrobText Ambitus #'(-5 . 0) \markup \column {
%   \doclink "AmbitusNoteHead"
%   \doclink "AmbitusLine"
%   \doclink "AmbitusAccidental"
%   \line {
%     \doclink "Ambitus"
%     \engraverlink "Ambitus" "s" } }

% \balloonGrobText NoteHead #'(1 . 2) \markup {
%   \with-url
%     "https://lilypond.org/doc/v2.23/Documentation/notation/outside-the-staff#balloon-help"
%     "Balloon annotation" }


% EOF
