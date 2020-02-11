\version "2.19.84"
\pointAndClickOff
#(set-global-staff-size 18)

% This file was created by Joram Berger, joramberger.de
% Currently there it is not available under a free license but I am willing to
% provide it under a Creative Commons license or something compatible with the
% LilyPond documentation upon request.

%{
open issues:

- Links are not clickable in SVG output
- Double underscores in links are not escaped correctly
- Finetuning the positions of labels
%}

\header {
  title = \markup \larger \larger "Visual LilyPond Index"
  tagline = ##f
}

\paper {
  indent = 3.8\cm
  ragged-bottom = ##t
  ragged-last-bottom = ##t
  system-system-spacing.padding = #7
  top-markup-spacing.basic-distance = 6
  fonts = #
  (make-pango-font-tree
   "Linux Libertine O"
   "Linux Biolinum O"
   "Ubuntu Mono"
   (/ (* staff-height pt) 2.5))
}


% Object link funtion from Thomas Morley
#(define (add-link strg)
   (lambda (grob)
     (let* ((stil (ly:grob-property grob 'stencil))
            (x-ext (ly:stencil-extent stil X))
            (y-ext (ly:stencil-extent stil Y))
            (link-stil (grob-interpret-markup
                        grob
                        (markup
                         #:with-url (string-append "http://lilypond.org/doc/v2.19/Documentation/notation/" strg)
                         #:with-dimensions x-ext y-ext
                         #:null)))
            (new-stil (ly:stencil-add
                       stil
                       link-stil)))
       (ly:grob-set-property! grob 'stencil new-stil))))

#(define-markup-command (doclink layout props text) (string?)
   "Return a text linked to the internal reference."
   (interpret-markup layout props
     #{
       \markup \with-url
       #(string-append "http://www.lilypond.org/doc/v2.19/Documentation/internals/"
          (string-downcase text) )
       \with-color #(x11-color "navy") #text
     #}))

#(define-markup-command (contextlink layout props text) (string?)
   "Return a text linked to the internal reference."
   (interpret-markup layout props
     #{
       \markup \with-url
       #(string-append "http://www.lilypond.org/doc/v2.19/Documentation/internals/"
          (string-downcase text) )
       \bold \larger \with-color #(x11-color "DarkRed") \rounded-box  #text
     #}))

% TODO: does not handle multiple underscores
#(define-markup-command (engraverlink layout props link text) (string? string?)
   "Return a text linked to the internal reference."
   (interpret-markup layout props
     #{
       \markup \with-url
       #(string-append
         (string-append "http://www.lilypond.org/doc/v2.19/Documentation/internals/"
           (if (string-contains link "_")
               (string-replace (string-downcase link) "_005f"
                 (string-contains (string-downcase link) "_")
                 (+ 1 (string-contains (string-downcase link) "_"))
                 )
               (string-downcase link)
               )
           )
         "_005fengraver")
       \italic \with-color #(x11-color "royal blue")
       #(if (string=? "s" text) "ꔮ" text)
     #}))

\markup \vspace #1
\markup \fontsize #-2 \with-color #grey \column {
  \line { \bold "Example:" "'BarNumber ꔮ' means:" }
  "the graphical object is called: BarNumber"
  "suggested search terms: bar number"
  "the engraver name (as not specified otherwise): Bar_number_engraver"
  \line {
    \bold "Legend:"
    \with-url
    "http://www.lilypond.org/doc/v2.19/Documentation/internals/all-layout-objects"
    \with-color #(x11-color "navy") "GraphicalObject (Grob)"
    \engraverlink #"engravers-and-performers" #"Engraver ꔮ"
    \smaller \contextlink #"Contexts"
  }
}

\markup {
  \vspace #2.5 \contextlink #"Score"
  \line {
    "["
    \doclink #"BreakAlignGroup"
    \doclink #"BreakAlignment"
    \doclink #"GraceSpacing"
    \doclink #"LeftEdge"
    \doclink #"NonMusicalPaperColumn"
  }
}
\markup {
  \line {
    " "
    \doclink #"PaperColumn"
    \doclink #"SpacingSpanner"
    \doclink #"VerticalAlignment"
    "]"
  }
}

\new Score \with { \consists "Balloon_engraver" \balloonLengthOff }
\new StaffGroup <<
  % Must be lower than the actual number of staff lines
  \override StaffGroup.SystemStartBracket.collapse-height = #1
  \override Score.SystemStartBar.collapse-height = #1
  \new Staff \with {
    \override InstrumentName.extra-offset = #'(2 . -1)
    instrumentName = \markup \column
    {
      \line { " " }
      \line { \doclink #"SystemStartBar" "|" }
      \line { \doclink #"SystemStartBrace" "{" }
      \line { \doclink #"SystemStartBracket" "→" }
      \line { \doclink #"SystemStartSquare" "[" }
      \line { \engraverlink #"System_start_delimiter" #"System_start_delimiter" }
    }
    %\override Stem.after-line-breaking = #(add-link "writing-parts#formatting-cue-notes")
    \override Clef.after-line-breaking = #(add-link "displaying-pitches#clef")
    \override TimeSignature.after-line-breaking = #(add-link "displaying-rhythms#time-signature")
    \override BarLine.after-line-breaking = #(add-link "bars#bar-lines")
  }
  \relative c''
  {
    \override Score.BarNumber.break-visibility = ##(#t #t #t)
    \override Score.BalloonTextItem.annotation-balloon = ##f
    %\override Score.SystemStartBracket.after-line-breaking = #(add-link "displaying-staves#grouping-staves")
    %\override Score.MetronomeMark.after-line-breaking = #(add-link "learning/adding-and-removing-engravers")
    %\override Score.BarNumber.after-line-breaking = #(add-link "bars#bar-numbers")
    \override Score.ParenthesesItem.after-line-breaking = #(add-link "inside-the-staff#parentheses")
    %\override Score.RehearsalMark.after-line-breaking = #(add-link "displaying-rhythms")
    %\override Score.FootnoteItem.after-line-breaking = #(add-link "learning/accidentals-and-key-signatures")
    \override Score.VoltaBracket.after-line-breaking = #(add-link "long-repeats#normal-repeats")
    %\override Score.VoltaBracketSpanner.after-line-breaking = #(add-link "writing-parts#formatting-cue-notes")

    \balloonGrobText #'MetronomeMark #'(-1 . 2) \markup \line{
      \engraverlink #"Metronome_mark" #"s"
      \doclink #"MetronomeMark"
    }
    \tempo Allegro
    a1

    \balloonGrobText #'BarNumber #'(0 . 2) \markup \line {
      \doclink #"BarNumber"
      \engraverlink #"Bar_number" #"s"
    }
    a1
    \revert Score.BarNumber.break-visibility
    \balloonGrobText #'RehearsalMark #'(1 . 1) \markup \column {
      \engraverlink #"Mark" #"Mark"
      \doclink #"RehearsalMark"
    }
    \mark \default
    \balloonGrobText #'ParenthesesItem #'(-1 . -2) \markup \column {
      \doclink #"ParenthesesItem"
      \engraverlink #"Parenthesis" #"Parenthesis"
    }

    \parenthesize
    a1
    \balloonGrobText #'VoltaBracket #'(1 . 1) \markup
    \doclink #"VoltaBracket"
    \balloonGrobText #'VoltaBracketSpanner #'(1 . 1) \markup
    \doclink #"VoltaBracketSpanner"
    \override TextScript.outside-staff-priority = #999

    %\balloonGrobText #'FootnoteItem #'(1 . 1) \markup \doclink #"FootnoteItem"
    \override Score.FootnoteSpanner.color = #red
    \once \override TextScript.extra-offset = #'(0 . -2)

    \repeat volta 2 {
      \footnote #'(1 . -2) \markup \fill-line {
        "Footnote"
        \with-url
        "http://www.joramberger.de"
        "© 2013 – 2020 Joram Berger · joramberger.de"
        " "
      }
      a1_\markup \column {
        \line {
          \doclink #"FootnoteItem"
          \engraverlink #"Footnote" #"Footnote"
        }
        \doclink #"FootnoteSpanner"
      }
    }
    \alternative {
      {
        a1^\markup \column{
          \line {
            \doclink #"VoltaBracket"
            \engraverlink #"Volta" #"Volta"
          }
          \doclink #"VoltaBracketSpanner"
        }
      }
      { b1 }
    }
    a1 \bar "|."
  }
>>

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\markup {
  \vspace #3 \contextlink #"Staff"
  %Accidental, AccidentalCautionary, AccidentalPlacement, AccidentalSuggestion,
  %BassFigure, BassFigureAlignment, BassFigureAlignmentPositioning, BassFigureBracket, BassFigureContinuation, BassFigureLine,
  [ \doclink #"DotColumn" \doclink #"LedgerLineSpanner" \doclink #"NoteCollision"
  \doclink #"RestCollision" \doclink #"ScriptRow" \doclink #"VerticalAxisGroup" ]
}
%PianoPedalBracket, SostenutoPedal, SostenutoPedalLineSpanner, SustainPedal, SustainPedalLineSpanner, UnaCordaPedal, UnaCordaPedalLineSpanner
\new Score
{
  \new Staff \with {
    \consists "Ambitus_engraver"
    \consists "Balloon_engraver"
    \balloonLengthOff
  }
  {
    \new Voice ="eins" \relative c'' {
      \balloonLengthOff
      \override Score.BalloonTextItem.annotation-balloon = ##f
      \override Staff.AmbitusNoteHead.after-line-breaking = #(add-link "displaying-pitches#ambitus")
      \override Staff.AmbitusLine.after-line-breaking = #(add-link "displaying-pitches#ambitus")
      \override Staff.AmbitusAccidental.after-line-breaking = #(add-link "displaying-pitches#ambitus")
      \override Staff.Clef.after-line-breaking = #(add-link "displaying-pitches#clef")
      \override Staff.TimeSignature.after-line-breaking = #(add-link "displaying-rhythms#time-signature")
      \override Staff.KeySignature.after-line-breaking = #(add-link "displaying-pitches#key-signature")
      \override Staff.BarLine.after-line-breaking = #(add-link "bars#bar-lines")
      \override Staff.CueClef.after-line-breaking = #(add-link "writing-parts#formatting-cue-notes")
      \override Staff.CueEndClef.after-line-breaking = #(add-link "writing-parts#formatting-cue-notes")
      \override Staff.OttavaBracket.after-line-breaking = #(add-link "displaying-pitches#ottava-brackets")
      \override NoteHead.after-line-breaking = #(add-link "writing-pitches")
      \override Rest.after-line-breaking = #(add-link "writing-rests#rests")
      \override Flag.after-line-breaking = #(add-link "writing-rhythms#durations")
      \override Beam.after-line-breaking = #(add-link "beams")
      \override Dots.after-line-breaking = #(add-link "writing-rhythms#durations")

      %\once \override Staff.BalloonTextItem.extra-offset = #'(0 . -4)
      \balloonGrobText #'Ambitus #'(-5 . 0)
      \markup \column {
        " "
        \line {
          \doclink #"InstrumentName"
          \engraverlink #"Instrument_name" #"s"
        }
        \doclink #"AmbitusNoteHead"
        \doclink #"AmbitusLine"
        \doclink #"AmbitusAccidental"
        \line {
          \doclink #"Ambitus"
          \engraverlink #"Ambitus" #"s"
        }
      }

      \balloonGrobText #'Clef #'(-1 . -2) \markup \line {
        \doclink #"Clef"
        \engraverlink #"Clef" #"s"
      }
      \balloonGrobText #'ClefModifier #'(1 . -1.5) \markup
      \doclink #"ClefModifier"
      \clef "treble_8"
      \balloonGrobText #'KeySignature #'(-1 . 3.2) \markup \line {
        \engraverlink #"Key" #"Key"
        \doclink #"KeySignature"
      }
      \time 3/4
      \balloonGrobText #'TimeSignature #'(-2 . 7) \markup \line {
        \engraverlink #"Time_signature" #"s"
        \doclink #"TimeSignature"
      }
      \key d \major
      a,2.
      \balloonGrobText #'BarLine #'(-1 . -1) \markup \line {
        \doclink #"BarLine"
        \engraverlink #"Bar" #"Bar"
      }
      \balloonGrobText #'KeyCancellation #'(0.5 . 4.5) \markup
      \doclink #"KeyCancellation"

      \balloonGrobText #'KeySignature #'(1 . 0.5) \markup
      \doclink #"KeySignature"

      \key g \major
      \balloonGrobText #'Accidental #'(3 . -3.5) \markup \line {
        \doclink #"Accidental"
        \engraverlink #"Accidental" #"s"
      }
      es4
      \balloonGrobText #'AccidentalCautionary #'(1 . -0.5) \markup
      \doclink #"AccidentalCautionary"
      es? r4 g2. g
      \cueClef "bass"
      \new CueVoice {
        \override TextScript.extra-offset = #'(4 . 7)
        b,_\markup \draw-line #'(-7 . 7)
      }
      \balloonGrobText #'CueEndClef #'(1 . -1) \markup \column {
        \doclink #"CueEndClef"
        \line {
          \doclink #"CueClef"
          \engraverlink #"Cue_clef" #"s"
        }
      }
      \cueClefUnset
      \balloonGrobText #'FootnoteItem #'(-1 . -2) \markup
      \doclink #"CueEndClef"
      \balloonGrobText #'FootnoteSpanner #'(-1 . -2) \markup
      \doclink #"CueEndClef"

      <>-\tweak #'extra-offset #'(-5 . 1) ^\markup \column {
        \engraverlink #"Ottava_spanner" #"Ottava_spanner"
        \doclink #"OttavaBracket"
      }
      \ottava #1
      \once\override TextScript.extra-offset = #'(15 . -12.5)
      a''^\markup \column {
        \doclink #"StaffSymbol"
        \doclink #"StaffSpacing"
      }
      \ottava #0
      \bar "|."
    }
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\markup {
  \vspace #1 \column {
    \line {
      \contextlink #"Voice"
      % CombineTextScript, DoublePercentRepeat, DoublePercentRepeatCounter, DoubleRepeatSlash,
    }
    % \line {
    %   InstrumentSwitch, LaissezVibrerTieColumn, LigatureBracket,
    %   %%MultiMeasureRest, MultiMeasureRestNumber, MultiMeasureRestText,
    %   NoteColumn, NoteSpacing,
    %  }
    % \line {
    %   PercentRepeat, PercentRepeatCounter, RepeatSlash, RepeatTieColumn, ScriptColumn,
    %   %%StemTremolo, StringNumber, StrokeFinger, TextSpanner,
    %   TieColumn,
    %  }
    % \line { " " }
  }
%%%, VoiceFollower.
}
\new Score \with {
  \consists "Balloon_engraver"
  \balloonLengthOff
}
{
  \new Voice ="eins"
  \relative c' {
    \override Score.BalloonTextItem.annotation-balloon = ##f
    \override Staff.Clef.after-line-breaking = #(add-link "displaying-pitches#clef")
    \override Staff.TimeSignature.after-line-breaking = #(add-link "displaying-rhythms#time-signature")
    \override Staff.KeySignature.after-line-breaking = #(add-link "displaying-pitches#key-signature")
    \override Staff.BarLine.after-line-breaking = #(add-link "bars#bar-lines")
    \override NoteHead.after-line-breaking = #(add-link "writing-pitches")
    \override Rest.after-line-breaking = #(add-link "writing-rests#rests")
    \override Flag.after-line-breaking = #(add-link "writing-rhythms#durations")
    \override Beam.after-line-breaking = #(add-link "beams")
    \override Dots.after-line-breaking = #(add-link "writing-rhythms#durations")

    \override Script.after-line-breaking = #(add-link "expressive-marks-attached-to-notes")
    \override Fingering.after-line-breaking = #(add-link "inside-the-staff#fingering-instructions")
    \override Arpeggio.after-line-breaking = #(add-link "expressive-marks-as-lines#arpeggio")
    \override Glissando.after-line-breaking = #(add-link "expressive-marks-as-lines#glissando")
    \override BreathingSign.after-line-breaking = #(add-link "expressive-marks-as-curves#breath-marks")
    \override DynamicTextSpanner.after-line-breaking = #(add-link "expressive-marks-attached-to-notes#dynamics")
    \override DynamicText.after-line-breaking = #(add-link "expressive-marks-attached-to-notes#dynamics")
    \override Hairpin.after-line-breaking = #(add-link "expressive-marks-attached-to-notes#dynamics")
    \override TrillSpanner.after-line-breaking = #(add-link "expressive-marks-as-lines#trills")
    \override TrillPitchGroup.after-line-breaking = #(add-link "expressive-marks-as-lines#trills")
    \override Slur.after-line-breaking = #(add-link "expressive-marks-as-curves#slurs")
    \override PhrasingSlur.after-line-breaking = #(add-link "expressive-marks-as-curves#phrasing-slurs")
    \override Tie.after-line-breaking = #(add-link "writing-rhythms#ties")
    \override RepeatTie.after-line-breaking = #(add-link "writing-rhythms#ties")
    \override LaissezVibrerTie.after-line-breaking = #(add-link "writing-rhythms#ties")
    \override BendAfter.after-line-breaking = #(add-link "expressive-marks-as-curves#falls-and-doits")
    \override TupletBracket.after-line-breaking = #(add-link "writing-rhythms#tuplets")
    \override TupletNumber.after-line-breaking = #(add-link "writing-rhythms#tuplets")
    \override ClusterSpanner.after-line-breaking = #(add-link "single-voice#clusters")

    % basic notation
    \balloonGrobText #'NoteHead #'(2 . -1) \markup \line {
      \engraverlink #"Note_head" #"s"
      \doclink #"NoteHead"
    }
    \balloonGrobText #'Stem #'(0.5 . 2.8) \markup \line {
      \doclink #"Stem"
      \engraverlink #"Stem" #"s"
    }
    d4 r
    \balloonGrobText #'Rest #'(1 . 2) \markup \line {
      \doclink #"Rest"
      \engraverlink #"Rest" #"s"
    }
    r r
    \balloonGrobText #'Flag #'(0 . 1) \markup
    \doclink #"Flag"
    g8\noBeam

    \once\override Staff.TextScript.extra-offset = #'(1 . 3)
    g^\markup
    \halign #-0.3  \line {
      \engraverlink #"Auto_beam" #"Auto_beam"
      \engraverlink #"Beam" #"s"
    }
    \once\override Staff.TextScript.extra-offset = #'(1 . -2)
    g16[ ^\markup
    \doclink #"Beam"
    g g g]
    \balloonGrobText #'Dots #'(0 . 3) \markup \line {
      \doclink #"Dots"
      \engraverlink #"Dots" #"s"
    }
    c8. c16

    \balloonGrobText #'Script #'(0.1 . 4) \markup \line {
      \doclink #"Script"
      \engraverlink #"Script" #"s"
    }
    c8-. a

    \balloonGrobText #'Fingering #'(3 . 2) \markup \line {
      \doclink #"Fingering"
      \engraverlink #"Fingering" #"s"
    }
    g4-1

    \balloonGrobText #'Arpeggio #'(-1 . -0.5) \markup \line {
      \doclink #"Arpeggio"
      \engraverlink #"Arpeggio" #"s"
    }
    <c, e g c>4\arpeggio
    \textLengthOff

    c\glissando_\markup \line {
      \doclink #"Glissando"
      \engraverlink #"Glissando" #"s"
    }
    c'^\markup {
      \halign #CENTER \line {
        \doclink #"BreathingSign"
        \engraverlink #"Breathing_sign" #"s"
      }
    }
    \breathe
    \break

    % Text and dynamics
    \balloonGrobText #'TextScript #'(0 . 1) \markup \column {
      \engraverlink #"Text" #"Text"
      \doclink #"TextScript"
    }
    c4^\markup
    \with-url "http://lilypond.org/doc/v2.19/Documentation/notation/writing-text"
    "Fine"\cresc

    \balloonGrobText #'NoteHead #'(1 . 2) \markup
    \with-url "http"
    "Annotation"
    \once\override Staff.TextScript.extra-offset = #'(-6.5 . 1)
    c4_\markup \doclink #"DynamicTextSpanner"

    \once\override Staff.TextScript.extra-offset = #'(0 . 3)
    c4^\markup \column {
      \engraverlink #"Balloon" #"Balloon"
      \doclink #"BalloonTextItem"
    }
    c4\!

    % Slurs and ties
    \once\override Staff.TextScript.extra-offset = #'(0 . 3)
    \balloonGrobText #'DynamicText #'(-1 . -2) \markup \line {
      \engraverlink #"Dynamic" #"Dynamic"
      \doclink #"DynamicText"
    }
    c\ff-\tweak #'extra-offset #'(0 . 1) _\markup \column {
      \doclink #"DynamicLineSpanner"
      \doclink #"Hairpin"
    }
    \>
    c
    \pitchedTrill
    c\!^\markup \column {
      \line {
        \engraverlink #"Trill_spanner" #"s"
        \doclink #"TrillSpanner"
        \doclink #"TrillPitchAccidental"
      }
      \line {
        \doclink #"TrillPitchGroup"
        \engraverlink #"Pitched_trill" #"Pitched_trill"
      }
      \doclink #"TrillPitchHead"
    }
    \startTrillSpan
    des? r
    \stopTrillSpan
    \bar "||"
    a(_\markup \line {
      \doclink #"Slur"
      \engraverlink #"Slur" #"s"
    }
    g) c\(
    g
    ^\markup \line {
      \doclink #"PhrasingSlur"
      \engraverlink #"Phrasin_slur" #"s"
    }
    _\markup \line {
      \doclink #"Tie"
      \engraverlink #"Tie" #"s"
    }
    ~ g

    \balloonGrobText #'RepeatTie #'(-1 . -6) \markup \line {
      \doclink #"RepeatTie"
      \engraverlink #"Repeat_tie" #"s"
    }
    c\repeatTie
    \balloonGrobText #'LaissezVibrerTie #'(0 . -9) \markup \line {
      \doclink #"LaissezVibrerTie"
      \engraverlink #"Laissez_vibrer" #"Laissez_vibrer"
    }
    c\laissezVibrer
    \balloonGrobText #'BendAfter #'(1 . 1) \markup \column {
      \engraverlink #"Bend" #"Bend"
      \doclink #"BendAfter"
    }

    e\)\bendAfter #-6
    \bar "||"

    \tuplet 3/2 {
      d4_\markup \line {
        \doclink #"TupletNumber"
        \engraverlink #"Tuplet" #"Tuplet"
      }
      c
      \once\override Staff.TextScript.extra-offset = #'(1.2 . 4.5)
      b_\markup \doclink #"TupletBracket"
    }

    \makeClusters {
      <c e>16  <b f'> <b g'>
      \once\override Staff.TextScript.extra-offset = #'(3 . 2)
      <c g>^\markup \halign #CENTER \column {
        \line {
          \doclink #"ClusterSpanner"
          \engraverlink #"Cluster_spanner" #"s"
        }
        \doclink #"ClusterSpannerBeacon"
      }
    }
    r4
    \bar "|."
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\markup { \vspace #1 \contextlink #"ChordNames" \vspace #-15 }

\new Score
{
  <<
    \new ChordNames \with {
      \consists "Balloon_engraver"
      \balloonLengthOff
      \override ChordName.after-line-breaking = #(add-link "displaying-chords")
    }
    \chordmode {
      \balloonGrobText #'ChordName #'(1 . 1) \markup {
        \doclink #"ChordName"
        \engraverlink #"Chord_name" #"s"
      }
      c1 g1 c1
    }
    \new Staff \with{
      \override InstrumentName.extra-offset = #'(-1.75 . -7.5)
      instrumentName = \markup \column
      {
        \line {
          \contextlink #"FiguredBass"
          \engraverlink #"Figured_bass" #"s"
        }
        \doclink #"BassFigure"
        \doclink #"BassFigureAlignment"
        \doclink #"BassFigurePositioning"
        \doclink #"BassFigureLine"
        \contextlink #"Lyrics"
      }
      \consists "Balloon_engraver"
      \balloonLengthOff

      \override Clef.after-line-breaking = #(add-link "displaying-pitches#clef")
      \override TimeSignature.after-line-breaking = #(add-link "displaying-rhythms#time-signature")
      \override BarLine.after-line-breaking = #(add-link "bars#bar-lines")
      \override NoteHead.after-line-breaking = #(add-link "writing-pitches")
      \override Dots.after-line-breaking = #(add-link "writing-rhythms#durations")
      \override Slur.after-line-breaking = #(add-link "expressive-marks-as-curves#slurs")
    }
    \new Voice = "voice" \relative c' {
      \override Score.BalloonTextItem.annotation-balloon = ##f
      \once\override Staff.TextScript.extra-offset = #'(25 . 3)
      \textLengthOff
      c4 d e f g a( b) c
      \once\override Staff.TextScript.extra-offset = #'(25 . 3)
      \once \override TextScript.outside-staff-priority = ##f
      c2 c
      \bar"|."
    }
    \new FiguredBass \with{
      \consists "Balloon_engraver"
      \balloonLengthOff
      \override VerticalAxisGroup.nonstaff-relatedstaff-spacing.padding = #1
    }
    \figuremode {
      \override BassFigure.after-line-breaking = #(add-link "figured-bass")
      \override BassFigureContinuation.after-line-breaking = #(add-link "figured-bass")
      \override BassFigureBracket.after-line-breaking = #(add-link "figured-bass")
      \bassFigureExtendersOn
      <5>2
      \balloonGrobText #'BassFigureBracket #'(1 . -3) \markup
      \doclink #"BassFigureBracket"
      <[6]>2
      \balloonGrobText #'BassFigureAlignmentPositioning #'(-1 . 4) \markup
      \doclink #"BassFigurePos"
      \balloonGrobText #'BassFigure #'(1 . -1) \markup
      \doclink #"BassFigureContinuation"
      <5> <5>
    }
    \new Lyrics \with {
      \consists "Balloon_engraver"
      \balloonLengthOff
      \override LyricText.Y-extent = #'(-0.5 . 3.5)
      \override LyricText.after-line-breaking = #(add-link "common-notation-for-vocal-music#aligning-lyrics-to-a-melody")
      \override StanzaNumber.after-line-breaking = #(add-link "stanzas#adding-stanza-numbers")

    }
    \lyricsto "voice" {
      \balloonGrobText #'StanzaNumber #'(1 . -1.5) \markup \line {
        \doclink #"StanzaNumber"
        \engraverlink #"Stanza_number" #"s"
      }
      \set stanza = "1."
      Lo -- rem ip -- sum

      \balloonGrobText #'LyricText #'(1 . -1) \markup \column {
        \line {
          \doclink #"LyricText"
          \doclink #"LyricSpace"
          \doclink #"LyricHyphen"
        }
        \line {
          "   "
          \engraverlink #"Lyric" #"Lyric"
          "              "
          \engraverlink #"Hyphen" #"Hyphen"
        }
      }
      do -- lor sit a -- met.
    }
  >>
}
