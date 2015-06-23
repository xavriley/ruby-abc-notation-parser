# Ruby ABC Notation Parser

Uses [Parslet](http://kschiess.github.io/parslet/) to understand [ABC notation](https://en.wikipedia.org/wiki/ABC_notation)

Based on the BNF for abc 1.6 found at [http://web.archive.org/web/20080309023424/http://www.norbeck.nu/abc/abcbnf.htm](http://web.archive.org/web/20080309023424/http://www.norbeck.nu/abc/abcbnf.htm)

Doesn't quite work yet but it will parse the most basic ABC files

```ruby
pp AbcParser.new.parse("X:1
T:The Legacy Jig
M:6/8
L:1/8
R:jig
K:G
GFG BAB | gfg gab | GFG BAB | d2A AFD |
GFG BAB | gfg gab | age edB | dBA AFD |
efe edB | dBA ABd | efe edB | gdB ABd |
efe edB | d2d def | gfe edB | dBA ABd | dBA AFD |
")

# outputs
{:abc_file=>
  [{:field_number=>{:number=>"1"@2},
    :field_title=>{:title=>"The Legacy Jig"@6},
    :field_key=>{:key=>"G"@41}},
   {:line=>"GFG BAB | gfg gab | GFG BAB | d2A AFD |\n"@43},
   {:line=>"GFG BAB | gfg gab | age edB | dBA AFD |\n"@83},
   {:line=>"efe edB | dBA ABd | efe edB | gdB ABd |\n"@123},
   {:line=>"efe edB | d2d def | gfe edB | dBA ABd | dBA AFD |\n"@163}]}
```
