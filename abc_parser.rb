require 'json'
require 'parslet'
require 'pp'

class AbcParser < Parslet::Parser
  # "%" is not included here (on purpose)!
  rule(:text_char) { match("[A-Za-z0-9\s\t]") | str('/') | str('"') | str("!") | str("\#") | str("$") | str("&") | str("'") | str("(") | str(")") | str("*") | str("+") | str(",") | str("-") | str(".") | str("|") | str(":") | str(";") | str("<") | str("=") | str(">") | str("?") | str("@") | str("[") | str("\\") | str("]") | str("^") | str("_") | str('`') | str("{") | str("|") | str("}") | str("~") }
  rule(:text) { text_char.repeat }
  rule(:digit) { match("[0-9]") }
  rule(:linefeed) { match("[\r\n]") }
  rule(:tex_command) { str("\\") >> text >> linefeed }
  rule(:space) { str(" ") | match("\t") }
  rule(:no_line_break) { str('\\') >> (str("\r") | str("\n")) }
  rule(:line_break) { str("!") >> linefeed }
  rule(:comment) { str("%") >> text >> (linefeed | line_break | no_line_break) }
  rule(:basenote) { match("[A-Ga-g]") }
  rule(:accidental) { str("^") | str("^^") | str("_") | str("__") | str("=") }

  rule(:end_of_line) { (str(" ") | match("\t")).repeat.maybe >> (str("%") >> text).maybe >> linefeed }
  rule(:part) { str("A") | str("B") | str("C") | str("D") | str("E") | str("F") | str("G") | str("H") | str("I") | str("J") | str("K") | str("L") | str("M") | str("N") | str("O") | str("P") | str("Q") | str("R") | str("S") | str("T") | str("U") | str("V") | str("X") | str("Y") | str("Z") }
  rule(:part_spec) { (part | ( str("(") >> part_spec.repeat(1) >> str(")") ) ) >> digit.repeat }
  rule(:parts) { part_spec.repeat(1) }

  ###########################################
  # abc_music
  ###########################################
  rule(:tie) { str("_") | str("-") }
  rule(:trill) { str("/") }
  rule(:broken_rhythm) { str("<").repeat(1) | str(">").repeat(1) }
  rule(:rest) { str("z") }
  rule(:note_length) { digit.maybe }
  rule(:octave) { match("[',]").repeat }
  rule(:pitch) { accidental.maybe.as(:accidental) >> basenote.as(:basenote) >> octave.maybe.as(:octave) }
  rule(:note_or_rest) { pitch | rest }
  rule(:note) { (note_or_rest.as(:note_pitch) >> note_length.maybe.as(:note_length) >> (tie.maybe.as(:tie_begin) | trill.maybe.as(:trill)) ).as(:note) }
  rule(:multi_note) { str("[") >> note >> str("]") }
  rule(:grace_notes) { str("{") >> pitch >> str("}") }
  rule(:gracings) { str("~") | str(".") | str("v") | str("u") | str("J") | str("R") | str("L") | str("H") }

  # These are order dependent in Parslet - XR
  rule(:nth_repeat) { ((str("[1") | str("[2") | str("|1") | str(":|2"))).as(:nth_repeat) }
  rule(:barline) { (str("||") | str("[|") | str("|]") | str(":|") | str("|:") | str("::") | str("|")).as(:barline) }

  rule(:field_part) { str("P:") >> part >> end_of_line }
  rule(:field_words) { str("W:") >> text >> end_of_line }

  rule(:user_defined) { match("[H-Z]") }

  # There are more chord types that could be understood
  rule(:chord_type) { str("m") | str("7") | str("m7") | str("0") | str("o") | str("+") | str("mb5") | str("sus") | str("sus4") | str("maj7") | str("mmaj7") | str("7sus4") | str("dim") | str("dim7") | str("7b5") | str("m7b5") | str("6") | str("b6") | str("m6") | str("mb6") | str("46") | str("maj9") | str("9") | str("add9") | str("7b9") | str("m9") }
  rule(:formal_chord) { basenote >> chord_type.maybe >> (str("|") >> basenote).maybe }
  rule(:guitar_chord) { str('"') >> (formal_chord | text) >> str('"') }

  rule(:note_stem) { guitar_chord.maybe >> grace_notes.maybe >> gracings.repeat.maybe >> (note | multi_note) }
  rule(:note_element) { note_stem >> broken_rhythm.maybe }

  rule(:tuplet_spec) { str("(") >> digit >> (str(":") >> digit.maybe >> (str(":") >> digit.maybe)) }
  rule(:tuplet_element) { tuplet_spec >> note_element.repeat(1) }

  rule(:line_ender) { comment | linefeed | line_break | no_line_break }
  rule(:element) { note_element | tuplet_element | slur | space | user_defined }
  rule(:bar) { (element.repeat >> (nth_repeat | barline)).as(:bar) }

  rule(:begin_slur) { str("(") }
  rule(:end_slur) { str(")") }

  rule(:slur) {
    begin_slur >>
    (
      (str('\\') >> element) |
      (end_slur.absent? >> element)
    ).repeat.as(:slur) >>
    end_slur
  }

  rule(:abc_line) { (bar.repeat >> line_ender).as(:line) | tex_command | mid_tune_field }
  rule(:abc_music) { abc_line.repeat >> linefeed.maybe }

  ###########################################
  # abc_header
  ###########################################

  rule(:note_length_strict) { digit >> str("/") >> digit }

  rule(:tempo) { digit | (str("C") >> note_length.maybe >> str("=") >> digit) | (note_length_strict >> str("=") >> digit) }

  # If we allow complex time signatures:
  # meter-fraction ::= 1*DIGIT *("+" 1*DIGIT) "/" 1*DIGIT
  rule(:meter_fraction) { digit >> str("/") >> digit }
  rule(:meter) { str("C") | str("C/") | meter_fraction }

  rule(:mode_minor) { (str("m")|str("M")) >> (str("i")|str("I")).maybe >> (str("n")|str("N")).maybe }
  rule(:mode_major) { (str("m")|str("M")) >> (str("a")|str("A")) >> (str("j")|str("J")) }
  rule(:mode_lydian) { (str("l")|str("L")) >> (str("y")|str("Y")) >> (str("d")|str("D")) }
  rule(:mode_ionian) { (str("i")|str("I")) >> (str("o")|str("O")) >> (str("n")|str("N")) }
  rule(:mode_mixolydian) { (str("m")|str("M")) >> (str("i")|str("I")) >> (str("x")|str("X")) }
  rule(:mode_dorian) { (str("d")|str("D")) >> (str("o")|str("O")) >> (str("r")|str("R")) }
  rule(:mode_aeolian) { (str("a")|str("A")) >> (str("e")|str("E")) >> (str("o")|str("O")) }
  rule(:mode_phrygian) { (str("p")|str("P")) >> (str("h")|str("H")) >> (str("r")|str("R")) }
  rule(:mode_locrian) { (str("l")|str("L")) >> (str("o")|str("O")) >> (str("c")|str("C")) }
  rule(:global_accidental) { accidental >> basenote }
  rule(:extratext) { match("[a-zA-z]") }
  rule(:mode) { mode_minor | mode_major | mode_lydian | mode_ionian | mode_mixolydian | mode_dorian | mode_aeolian | mode_phrygian | mode_locrian }
  rule(:mode_spec) { match("\s").maybe >> mode >> extratext.maybe }
  rule(:key_accidental) { str("#") | str("b") }
  rule(:keynote) { basenote >> key_accidental.maybe }
  rule(:key_spec) { keynote >> mode_spec.maybe >> (str(" ") | global_accidental).repeat.maybe }
  rule(:key) { key_spec | str("HP") | str("Hp") }

  # maybe some of these field definitions should include an optional space:
  # field-area ::= "A:" [" "] text end-of-line
  rule(:field_area) { str("A:") >> text >> end_of_line }
  rule(:field_book) { str("B:") >> text >> end_of_line }
  rule(:field_composer) { str("C:") >> text >> end_of_line }
  rule(:field_discography) { str("D:") >> text >> end_of_line }
  rule(:field_elemskip) { str("E:") >> text >> end_of_line }
  rule(:field_group) { str("G:") >> text >> end_of_line }
  rule(:field_history) { str("H:") >> (text >> end_of_line).repeat(1) }
  rule(:field_information) { str("I:") >> text >> end_of_line }
  rule(:field_default_length) { str("L:") >> note_length_strict.as(:default_note_length) >> end_of_line }
  rule(:field_meter) { str("M:") >> meter.as(:meter) >> end_of_line }
  rule(:field_notes) { str("N:") >> text >> end_of_line }
  rule(:field_origin) { str("O:") >> text >> end_of_line }
  rule(:field_parts) { str("P:") >> parts >> end_of_line }
  rule(:field_tempo) { str("Q:") >> tempo.as(:tempo) >> end_of_line }
  rule(:field_rhythm) { str("R:") >> text.as(:rhythm) >> end_of_line }
  rule(:field_source) { str("S:") >> text >> end_of_line }
  rule(:field_transcrnotes) { str("Z:") >> text >> end_of_line }
  rule(:field_key) { str("K:") >> key.as(:key) >> end_of_line }

  # field-file and field-words may not be in header (?)
  rule(:other_fields) { file_fields | field_number.as(:field_number) | field_title | field_area | field_book | field_composer | field_discography | field_elemskip | field_group | field_history | field_information | field_default_length | field_meter | field_notes | field_origin | field_parts | field_tempo | field_rhythm | field_source | field_transcrnotes | comment }
  rule(:field_title) { str("T:") >> text.as(:title) >> end_of_line }
  rule(:field_number) { str("X:") >> digit.repeat.as(:number) >> end_of_line }

  # field-rhythm may not be in tune (?) field-voice not defined yet
  rule(:tune_field) { field_elemskip | field_key | field_default_length | field_meter | field_part | field_tempo | field_title | field_words }
  rule(:mid_tune_field) { tune_field }

  # In practice, many tunes are e-mailed without field-number,
  # so those wishing to implement an abc parser should treat this
  # field as optional.
  rule(:abc_header) { other_fields.repeat >> field_key.as(:field_key) }
  rule(:abc_tune) { abc_header.as(:abc_header) >> abc_music.as(:abc_music) }

  rule(:field_file) { str("F:") >> text.as(:field_file) >> end_of_line }
  rule(:file_fields) { field_file | field_book | field_group | field_history | field_information | field_meter | field_origin | field_rhythm } 

  rule(:abc_file) { (abc_tune | comment | linefeed | tex_command | file_fields).repeat.as(:abc_file) }

  root(:abc_music)
end

class AbcTransformer < Parslet::Transform
  KEY_LOOKUP = {
    :maj => [""]*7,
    :min => ["", "", "", "", "", "", ""],
  }

  def initialize(opts = {})
    @default_note_length = opts[:note_length]
    @key = opts[:key]
  end

  # matches a subtree with these exact keys
  rule(:accidental => simple(:acc),
       :basenote => simple(:note),
       :octave => simple(:oct)) {
         sp_acc = case acc
         when "^"
           "s"
         when "_"
           "b"
         when "="
           ""
         else
           ""
         end
         pitch_class = "#{note.to_s.downcase}#{sp_acc}"

         base_octave = (note.to_s[/[A-G]/] ? 4 : 5)
         additional_octaves = oct.to_s.chars.map {|x| ((x == ",") ? -1 : ((x == "'") ? 1 : 0))}
         additional_octaves.each {|o|
           base_octave = base_octave + o
         }

         absolute_pitch = "#{pitch_class}#{base_octave}"

         {:accidental => acc, :basenote => note, :octave => oct, :absolute_pitch => absolute_pitch}
       }
end

INPUT = "X:1
T:The Legacy Jig
M:6/8
L:1/8
R:jig
K:G
GFG BAB | (gfg gab) | GFG BAB | d2A AFD |
GFG BAB | gfg gab | age edB | dBA AFD :| dBA ABd |:
efe edB | dBA ABd | efe edB | gdB ABd |
efe edB | d2z def | gfe edB |1 dBA ABd :|2 dBA AFD |]
"

BACH_FULL = <<-BACH
ef | g2fe ^d2ef | B2^c^d e2 =d=c |\
  B2AG F2GA | BA GF E2ef |\
  g2fe ^d2ef | B2^c^d e2=d=c | B2AG F2DG | G6::\
  BG | d2Ac B2gd | e2Bd c2BA | ^G2AB c2BA | A4-A2dA |\
  B2gd e2Bd | c2ae f2^ce | d2^cB ^A/B/A/B/A/B/A/B/ |\
  B4-B2bf | ^g2fe a2e=g | f2ed g2d=f | e2ae f2^ce |\
  ^d2B2-B4| eB c2dA B2| cG A2BF G2| FE ^D2EF G2| FE E4:|
BACH

BACH = <<-BACH
ef | g2fe ^d2ef | B2^c^d e2 =d=c |\
  B2AG F2GA | BA GF E2ef |\
  ^d2B2-B4| eB c2dA B2| cG A2BF G2| FE ^D2EF G2| FE E4:|
BACH

SAILOR = <<-SAILOR
X: 11
T:Sweep's Hornpipe, The
M:4/4
L:1/8
H:1837
S:John Moore of Shropshire
Z:vmp.John Adams
K:G
D2|G2 BG E2 cA | FGAF G2 Bd | dcAc cBGB | ABcA GFED | GABG ABcA |
BcdB cdef | gfgd ecAF | G2G2G2 | Bc| dBdB g2 Bc| dedB G2 Bd | dcAc cBGB |
ABcA GFED | GABG ABcA | BcdB cdef | gfgd ecAF | G2G2G2:|
SAILOR

#puts BACH
parser = AbcParser.new
tree = parser.parse(BACH_FULL)
puts tree
# parse header
# get note_length, time_sig, key

#lol at this code
# note_length = parser.parse(INPUT)[:abc_file].first[:abc_header][1..-1].select {|x| x[:default_note_length] }.first.values.first.to_s
# key = parser.parse(INPUT)[:abc_file].first[:abc_header][1..-1].select {|x| x[:field_key] }.first.values.first[:key].to_s
# meter = parser.parse(INPUT)[:abc_file].first[:abc_header][1..-1].select {|x| x[:meter] }.first.values.first.to_s

#puts AbcTransformer.new.apply(tree).to_json
