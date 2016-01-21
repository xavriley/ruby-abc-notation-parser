require 'parslet'

class TidalParser < Parslet::Parser
  # added by me
  # space
  rule(:space) {
    match('\s').repeat(1)
  }
  rule(:space?) {
    space.maybe
  }

  rule(:sign) { str('+').as(:positive) | str('-').as(:negative) }

  # Tidal defs follow
  #
  # double
  # vocable
  # bool
  # int
  # rational
  # colour
  #
  # braces
  # brackets
  # parens
  # angles
  # symbol
  rule(:symbol) { match('[a-z]').repeat(1).as(:symbol) >> space }
  # natural
  # integer
  rule(:integer) {
    (sign.maybe >> match("[0-9]").repeat(1).as(:integer)) >> space?
  }

  # float
  rule(:float) {
    (
      integer >> ( str('.') >> match('[0-9]').repeat(1) | str('e') >> match('[0-9]').repeat(1)).as(:e)
    ).as(:float) >> space?
  }

  # naturalOrFloat
  rule(:intOrFloat) { (float | integer ) } # order dependent! most specific has to go first

  # rest
  rule(:rest)       { (str('~') | str('rest')).as(:rest) }



  rule(:atom) { (intOrFloat).as(:atom) }

  root(:atom)
end

TEST_DOC=%q{+10.1234}

parser = TidalParser.new
tree = parser.parse(TEST_DOC)
puts tree
