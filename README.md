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

## Supported characters

* **Accented Latin letters**: any letter whose Unicode decomposition is a base letter plus
  grave, acute, circumflex, tilde, macron, breve, dot above/below, diaeresis, ring, double acute,
  caron, cedilla, comma below, ogonek or macron below.
  This covers essentially all European languages: é ñ ö å ç š ő ą ż ř ů ğ ș ț ā ė ł …
* **Special letters**: ß æ ø œ ł ı ð þ ŋ đ ĳ and Serbo-Croatian digraphs (ǆ ǉ ǌ)
* **Greek letters** (via `textgreek`): α … ω, Α … Ω
* **Punctuation**: – — ‘ ’ “ ” „ « » ‹ › … • † ‡ § ¶ ¡ ¿, special spaces
* **Symbols**: € £ ¥ ¢ © ® ™ ° ± × ÷ µ ‰ № √ ½ ¼ ¾ → ≤ ≥ ≈ ∞ …
* **Super/subscripts**: ⁰¹²³…⁹ ₀₁₂…₉ ⁺ ⁻
* LaTeX special characters `& % # ~ ^ \ |` are escaped.

The output assumes the following in the preamble:

```latex
\usepackage[T1]{fontenc}
\usepackage{textcomp,textgreek,eurosym}
```

Not supported: letters with several stacked accents (ế, ǘ, ậ), Vietnamese hook/horn (ả, ơ, ư),
IPA letters, and some rare phonetic accents. Unknown characters raise an error showing their context.
