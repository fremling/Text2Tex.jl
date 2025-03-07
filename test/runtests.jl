
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
@test text2tex("ıłğČ") == "{\\i}{\\l}{\\v g}{\\v C}"
