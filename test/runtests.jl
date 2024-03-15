
using Test

@test Text2Tex("A<sub>B</sub>"=>"A\\textsubscript{B}$")
@test Text2Tex("A<br>B"=>"A\\\\B")

@test Text2Tex("&’"=>"\\&\'")

@test  Text2Tex("Wte<sub>2</sub>B") == "Wte\\textsubscript{2}B"
@test  Text2Tex("Wte<sub>1</sub>") == "Wte\\textsubscript{1}"
@test  Text2Tex("G<sub>10</sub>A") == "G\\textsubscript{10}A"
@test  Text2Tex("G<sup>10</sup>A") == "G\\textsuperscript{10}A"
