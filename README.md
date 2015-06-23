# Ruby ABC Notation Parser

Uses [Parslet](http://kschiess.github.io/parslet/) to understand [ABC notation](https://en.wikipedia.org/wiki/ABC_notation)

Based on the BNF for abc 1.6 found at [http://web.archive.org/web/20080309023424/http://www.norbeck.nu/abc/abcbnf.htm](http://web.archive.org/web/20080309023424/http://www.norbeck.nu/abc/abcbnf.htm)

Doesn't fully work yet but it will parse the most basic ABC files

### Todos

- [ ] Fix slurs across barlines
- [ ] Fix ties and tuplets to group notes
- [ ] Figure out default octave info
- [ ] Add default length to notes based on header
- [ ] Tests!
- [ ] Figure out a useable output format

```ruby
pp AbcParser.new.parse("X:1
T:The Legacy Jig
M:6/8
L:1/8
R:jig
K:G
GFG BAB | (gfg gab) | GFG BAB | d2A AFD |
GFG BAB | gfg gab | age edB | dBA AFD :| dBA ABd |:
efe edB | dBA ABd | efe edB | gdB ABd |
efe edB | d2d def | gfe edB |1 dBA ABd :|2 dBA AFD |]
")

# outputs
{:abc_file=>
  [{:field_number=>{:number=>"1"@2},
    :field_title=>{:title=>"The Legacy Jig"@6},
    :field_key=>{:key=>"G"@41}},
   {:line=>
     [{:bar=>
        [{:note=>{:note_pitch=>"G"@43, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"F"@44, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"G"@45, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@47, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@48, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@49, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@51}]},
      {:bar=>
        [{:slur=>
           [{:note=>{:note_pitch=>"g"@54, :note_length=>"", :tie_begin=>nil}},
            {:note=>{:note_pitch=>"f"@55, :note_length=>"", :tie_begin=>nil}},
            {:note=>{:note_pitch=>"g"@56, :note_length=>"", :tie_begin=>nil}},
            {:note=>{:note_pitch=>"g"@58, :note_length=>"", :tie_begin=>nil}},
            {:note=>{:note_pitch=>"a"@59, :note_length=>"", :tie_begin=>nil}},
            {:note=>
              {:note_pitch=>"b"@60, :note_length=>"", :tie_begin=>nil}}]},
         {:barline=>"|"@63}]},
      {:bar=>
        [{:note=>{:note_pitch=>"G"@65, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"F"@66, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"G"@67, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@69, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@70, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@71, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@73}]},
      {:bar=>
        [{:note=>{:note_pitch=>"d"@75, :note_length=>"2"@76, :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@77, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@79, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"F"@80, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"D"@81, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@83}]}]},
   {:line=>
     [{:bar=>
        [{:note=>{:note_pitch=>"G"@85, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"F"@86, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"G"@87, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@89, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@90, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@91, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@93}]},
      {:bar=>
        [{:note=>{:note_pitch=>"g"@95, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"f"@96, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"g"@97, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"g"@99, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"a"@100, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"b"@101, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@103}]},
      {:bar=>
        [{:note=>{:note_pitch=>"a"@105, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"g"@106, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@107, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@109, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@110, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@111, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@113}]},
      {:bar=>
        [{:note=>{:note_pitch=>"d"@115, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@116, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@117, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@119, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"F"@120, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"D"@121, :note_length=>"", :tie_begin=>nil}},
         {:barline=>":|"@123}]},
      {:bar=>
        [{:note=>{:note_pitch=>"d"@126, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@127, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@128, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@130, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@131, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@132, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|:"@134}]}]},
   {:line=>
     [{:bar=>
        [{:note=>{:note_pitch=>"e"@137, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"f"@138, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@139, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@141, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@142, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@143, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@145}]},
      {:bar=>
        [{:note=>{:note_pitch=>"d"@147, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@148, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@149, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@151, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@152, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@153, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@155}]},
      {:bar=>
        [{:note=>{:note_pitch=>"e"@157, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"f"@158, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@159, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@161, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@162, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@163, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@165}]},
      {:bar=>
        [{:note=>{:note_pitch=>"g"@167, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@168, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@169, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@171, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@172, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@173, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@175}]}]},
   {:line=>
     [{:bar=>
        [{:note=>{:note_pitch=>"e"@177, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"f"@178, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@179, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@181, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@182, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@183, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@185}]},
      {:bar=>
        [{:note=>
           {:note_pitch=>"d"@187, :note_length=>"2"@188, :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@189, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@191, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@192, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"f"@193, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|"@195}]},
      {:bar=>
        [{:note=>{:note_pitch=>"g"@197, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"f"@198, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@199, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"e"@201, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@202, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@203, :note_length=>"", :tie_begin=>nil}},
         {:nth_repeat=>"|1"@205}]},
      {:bar=>
        [{:note=>{:note_pitch=>"d"@208, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@209, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@210, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@212, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@213, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"d"@214, :note_length=>"", :tie_begin=>nil}},
         {:nth_repeat=>":|2"@216}]},
      {:bar=>
        [{:note=>{:note_pitch=>"d"@220, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"B"@221, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@222, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"A"@224, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"F"@225, :note_length=>"", :tie_begin=>nil}},
         {:note=>{:note_pitch=>"D"@226, :note_length=>"", :tie_begin=>nil}},
         {:barline=>"|]"@228}]}]}]}
```
