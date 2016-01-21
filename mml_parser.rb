require 'json'
require 'parslet'
require 'pp'
require 'rspec'
require 'parslet/rig/rspec'

class MmlParser < Parslet::Parser
  rule(:space) { str(" ") }
  rule(:linefeed) { match("[\r\n]") }
  rule(:empty_line) { str("") }
  rule(:integer)    { match("[0-9]").repeat(1) }

  rule(:channel)    { match("[ABCDE]").as(:channel).repeat }
  rule(:note)       { match("[abcdefg]").as(:note) >> (str("+").as(:sharp) | str("-").as(:flat)).maybe >> integer.maybe.as(:len) >> dynamic {|source, context| require 'pry'; binding.pry } }
  rule(:rest)       { str("r").as(:rest) >> integer.maybe.as(:len) }
  rule(:tempo)      { str("t") >> integer.as(:tempo) }

  rule(:mml_header) { (str("#") >> match("[A-Z\-]").repeat(1).as(:instruction) >> space >> (linefeed.absent? >> any).repeat.as(:value)).as(:header) }
  rule(:mml_macro)  { (str("@") >> (match("[A-Za-z\-]").repeat(1) >> integer.as(:num)).as(:instruction) >> (space.maybe >> str("=") >> space.maybe) >> (linefeed.absent? >> any).repeat.as(:value)).as(:macro) }
  rule(:mml_line)   { channel >> scope { space >> ((note | rest | tempo) >> space.maybe).repeat } }

  rule(:mml_tempo) { str("") }
  rule(:mml_volume) { str("") }
  rule(:mml_blank_line) { str("") }

  rule(:comment) { str(";") >> (linefeed.absent? >> any).repeat }
  rule(:comment_block) { str("/* ~ */") }

  #rule(:mml_doc) { ((mml_header | mml_channel | mml_tempo | mml_volume) >> linefeed).repeat(1) }
  rule(:mml_doc) { scope { ((mml_header | mml_blank_line) >> linefeed).repeat } }
  root(:mml_doc)
end

mml = <<-MML
#TITLE My First NES Chip
#COMPOSER Nullsleep
#PROGRAMER 2003 Jeremiah Johnson

@v0 = { 10 9 8 7 6 5 4 3 2 }

MML

describe MmlParser  do
  let(:parser) { MmlParser.new }
  context "simple_rule" do
    it "should parse headers" do
      expect(parser.mml_header).to parse("#TITLE My test MML parser")
    end

    it "should parse macros" do
      expect(parser.mml_macro).to parse("@v1 = { 0 1 2 3 }")
    end

    it "should parse comments" do
      expect(parser.comment).to parse("; this is a comment")
      #expect(parser.comment_block).to parse("/* ~ */\n foo baz\n/* ~ */")
    end

    it "should parse notes" do
      expect(parser.note).to parse("c")
      expect(parser.note).to parse("c4")
      expect(parser.note).to parse("c+4")
    end

    it "should parse rests" do
      expect(parser.rest).to parse("r")
      expect(parser.rest).to parse("r4")
    end

    it "should parse lines of notes with a channel" do
      expect(parser.mml_line).to parse("A c d e f g r4")
    end
  end
end

RSpec::Core::Runner.run([])

# #TITLE My First NES Chip
# #COMPOSER Nullsleep
# #PROGRAMER 2003 Jeremiah Johnson
#
# @v0 = { 10 9 8 7 6 5 4 3 2 }
# @v1 = { 15 15 14 14 13 13 12 12 11 11 10 10 9 9 8 8 7 7 6 6 }

# ABCDE t150

# A l8 o4 @01 @v0
# A [c d e f @v1 g4 @v0 a16 b16 >c c d e f @v1 g4 @v0 a16 b16 >c<<]2

# pp MmlParser.new.parse(mml)
