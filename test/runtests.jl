
using Test

using Text2Tex

@test text2tex(2) == "2"
@test text2tex(234) == "234"
@test text2tex(2.34) == "2.34"
@test text2tex(0) == "0"
@test text2tex(0.0) == "0.0"

@test text2tex("A<sub>B</sub>") == "A\\textsubscript{B}"
@test text2tex("A<br>B") == "A\\\\B"

@test  text2tex("Wte<sub>2</sub>B") == "Wte\\textsubscript{2}B"
@test  text2tex("Wte<sub>1</sub>") == "Wte\\textsubscript{1}"
@test  text2tex("G<sub>10</sub>A") == "G\\textsubscript{10}A"
@test  text2tex("G<sup>10</sup>A") == "G\\textsuperscript{10}A"

@test text2tex("&’") == "{\\&}\'"
@test text2tex("a+b") == "a+b"
@test text2tex("π") == "{\\textpi}"
@test text2tex("Γ") == "{\\textGamma}"


@test text2tex("åäö") == "{\\aa}{\\\"a}{\\\"o}"

@test text2tex("me and you?") == "me and you?"

@test text2tex("Straße") == "Stra{\\ss}e"

@test text2tex("ş") == "{\\c s}"

@test text2tex("şç") == "{\\c s}{\\c c}"
@test text2tex("ıłğČ") == "{\\i}{\\l}{\\u g}{\\v C}"

### Accents via Unicode decomposition
@test text2tex("é") == "{\\'e}"
@test text2tex("í") == "{\\'\\i}"           # dotless i under accents above
@test text2tex("ị") == "{\\d i}"            # ...but not below
@test text2tex("ñ") == "{\\~n}"
@test text2tex("ő") == "{\\H o}"
@test text2tex("ą") == "{\\k a}"
@test text2tex("ů") == "{\\r u}"
@test text2tex("ā") == "{\\=a}"
@test text2tex("ż") == "{\\.z}"
@test text2tex("ǽ") == "{\\'{\\ae}}"        # accent on special letter
@test text2tex("é") == "{\\'e}"       # decomposed input
@test text2tex("Dvořák") == "Dvo{\\v r}{\\'a}k"

### Special letters, punctuation and symbols
@test text2tex("æøÆØœðþŋđ") == "{\\ae}{\\o}{\\AE}{\\O}{\\oe}{\\dh}{\\th}{\\ng}{\\dj}"
@test text2tex("a–b—c") == "a--b---c"
@test text2tex("“x”") == "``x''"
@test text2tex("50%") == "50{\\%}"
@test text2tex("H₂O") == "H\\textsubscript{2}O"
@test text2tex("m³") == "m\\textsuperscript{3}"
@test text2tex("αΩ") == "{\\textalpha}{\\textOmega}"
@test text2tex("25°C") == "25{\\textdegree}C"
@test_throws ErrorException text2tex("😀")

### More accents
@test text2tex("à") == "{\\`a}"
@test text2tex("ê") == "{\\^e}"
@test text2tex("Ê") == "{\\^E}"
@test text2tex("ĭ") == "{\\u \\i}"
@test text2tex("ǰ") == "{\\v \\j}"
@test text2tex("Í") == "{\\'I}"           # capital I keeps no dotless form
@test text2tex("İ") == "{\\.I}"
@test text2tex("į") == "{\\k i}"          # ogonek is below: keep the dot
@test text2tex("ș") == "{\\c s}"          # comma below
@test text2tex("ţ") == "{\\c t}"
@test text2tex("ḇ") == "{\\b b}"
@test text2tex("ř") == "{\\v r}"
@test text2tex("Ű") == "{\\H U}"
@test text2tex("Ǿ") == "{\\'{\\O}}"      # composed from Ø + combining acute
@test text2tex("Ålesund") == "{\\AA}lesund"
@test text2tex("Łódź") == "{\\L}{\\'o}d{\\'z}"
@test text2tex("Đoković") == "{\\DJ}okovi{\\'c}"
@test text2tex("Þórr") == "{\\TH}{\\'o}rr"
@test text2tex("ǆ") == "d{\\v z}"

### Escapes, spaces, symbols
@test text2tex("#1 & ~^\\|") == "{\\#}1 {\\&} {\\textasciitilde}{\\textasciicircum}{\\textbackslash}{\\textbar}"
@test text2tex("a\u00A0b") == "a~b"
@test text2tex("a\u2009b") == "a\\,b"
@test text2tex("«oui»") == "{\\guillemotleft}oui{\\guillemotright}"
@test text2tex("„Ja“") == "{\\quotedblbase}Ja``"
@test text2tex("…") == "{\\ldots}"
@test text2tex("€£¥") == "{\\euro}{\\pounds}{\\textyen}"
@test text2tex("±×÷") == "{\\textpm}{\\texttimes}{\\textdiv}"
@test text2tex("\u00B5m") == "{\\textmu}m"   # micro sign
@test text2tex("μ") == "{\\textmu}"           # Greek mu
@test text2tex("ς") == "{\\textfinalsigma}"
@test text2tex("x⁻¹") == "x\\textsuperscript{-}\\textsuperscript{1}"
@test text2tex("ﬁ") == "fi"
@test text2tex("a≤b") == "a\\ensuremath{\\leq}b"

### Unsupported characters give an informative error
@test_throws ErrorException text2tex("ế")      # stacked accents
@test_throws ErrorException text2tex("ơ")      # horn
@test_throws "Unknown character in \"abc\"+'😀'" text2tex("abc😀def")
