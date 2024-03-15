# Text2Tex.jl
Lightweight library that converts simple html markdown and unicode characters to the corresponding latex strings.

This pachage can for buest to convert e.g. names or html formated chemical formulas to a tex friendly format.

```julia
using Text2Tex

julia> text2tex("Straße")
"Stra{\\ss}e"

julia> text2tex("I can handle<sub>subscripts</sub>")
"I can handle\\textsubscript{subscripts}"

julia> text2tex("I can handle special characters like å, ä, ö")
"I can handle special characters like {\\aa}, {\\\"a}, {\\\"o}"

```

The list of convertable characters is not complete and will be extended with time (or uppon request).
Here is a short list of supported characters:

ı ł ß ş ç ğ Š š Č ö ë ü ä è à á ń ó í ź é ú ć

