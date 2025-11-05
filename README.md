# Text2Tex.jl
A lightweight library that converts simple HTML markdown and Unicode characters to the corresponding latex strings.

This package can be used to convert names or HTML-formatted chemical formulas to a tex-friendly format.

```julia
using Text2Tex

julia> text2tex("Straße")
"Stra{\\ss}e"

julia> text2tex("I can handle<sub>subscripts</sub>")
"I can handle\\textsubscript{subscripts}"

julia> text2tex("I can handle special characters like å, ä, ö")
"I can handle special characters like {\\aa}, {\\\"a}, {\\\"o}"

```

The convertible characters list is incomplete but will be extended over time (or upon request).
Here is a short list of some supported characters:

ı ł ß ş ç ğ Š š Č ö ë ü ä è à á ń ó í ź é ú ć

