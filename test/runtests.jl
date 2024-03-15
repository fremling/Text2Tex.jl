
using Test

using Text2Tex

@test text2tex("A<sub>B</sub>") == "A\\textsubscript{B}"
@test text2tex("A<br>B") == "A\\\\B"

@test  text2tex("Wte<sub>2</sub>B") == "Wte\\textsubscript{2}B"
@test  text2tex("Wte<sub>1</sub>") == "Wte\\textsubscript{1}"
@test  text2tex("G<sub>10</sub>A") == "G\\textsubscript{10}A"
@test  text2tex("G<sup>10</sup>A") == "G\\textsuperscript{10}A"

@test text2tex("&’") == "{\\&}\'"


@test text2tex("åäö") == "{\\aa}{{\\\"}a}{{\\\"}o}"

@test text2tex("Straße") == "Stra{\\ss}e"

@test text2tex("ş") == "{{\\c}s}"
