module Text2Tex

export text2tex

function text2tex(stringIn::AbstractString;verbose=false,context=10::Integer)
    verbose && println("Decoding:'$stringIn'")
    ### Compose base letter + combining marks (e.g. "é") into single characters
    stringIn = Base.Unicode.normalize(stringIn, :NFC)
    ErrorStr=""
    charString = try join([text2tex(char) for char in stringIn])
    catch y
        ###Do character by character
        str = ""
        for (cno,char) in enumerate(stringIn) ###Try again one character at a time
            #println(cno," char:",char)
            t2tc = try text2tex(char)
            catch ### Catch the error and display the context
                noLeft = minimum([cno-1,context])
                StringLeft=join(collect(stringIn)[(cno-noLeft):(cno-1)])
                ErrorStr="Unknown character in \""*StringLeft*"\"+'"*char*"'"*". Cannot decode to TeX"
                break
            end
        end
    end
    if ErrorStr != ""
        error(ErrorStr)
    end

    ##Search for <sub>
    charString = replace(charString, "<sub>"=>"\\textsubscript{")
    charString = replace(charString, "<sup>"=>"\\textsuperscript{")
    charString = replace(charString, "</sub>"=>"}")
    charString = replace(charString, "</sup>"=>"}")
    charString = replace(charString, "<br>"=>"\\\\")
    return charString
end


text2tex(::Missing) = ""
text2tex(n::Integer) = "$n"
text2tex(n::Real) = "$n"

#https://tex.stackexchange.com/tags/accents/info
#https://tex.stackexchange.com/questions/8857/how-to-type-special-accented-letters-in-latex

### Combining diacritical marks => (LaTeX accent command, is it a letter command?)
### Letter commands (\v, \c, ...) need a space before the argument, symbol ones (\', \") don't.
const ACCENTS = Dict{Char,Tuple{String,Bool}}(
    '̀' => ("`",  false), # grave        è
    '́' => ("'",  false), # acute        é
    '̂' => ("^",  false), # circumflex   ê
    '̃' => ("~",  false), # tilde        ñ
    '̄' => ("=",  false), # macron       ā
    '̆' => ("u",  true),  # breve        ă ğ
    '̇' => (".",  false), # dot above    ż
    '̈' => ("\"", false), # diaeresis    ö
    '̊' => ("r",  true),  # ring above   ů
    '̋' => ("H",  true),  # double acute ő
    '̌' => ("v",  true),  # caron        š
    '̣' => ("d",  true),  # dot below    ạ
    '̦' => ("c",  true),  # comma below  ș ț (typeset as cedilla; use the combelow package for a true comma)
    '̧' => ("c",  true),  # cedilla      ç
    '̨' => ("k",  true),  # ogonek       ą
    '̱' => ("b",  true),  # macron below ḇ
)
### Accents placed below the letter: i and j keep their dot
const BELOW_ACCENTS = Set(['̣','̦','̧','̨','̱'])

### Characters that do not decompose into letter + accent, or that need a special treatment.
### Packages: textcomp (symbols), textgreek (Greek), eurosym (\euro), T1 fontenc (\dh, \th, \ng, \dj)
const SPECIAL = Dict{Char,String}(
    ### Letters
    'å' => "{\\aa}",  'Å' => "{\\AA}",
    'æ' => "{\\ae}",  'Æ' => "{\\AE}",
    'œ' => "{\\oe}",  'Œ' => "{\\OE}",
    'ø' => "{\\o}",   'Ø' => "{\\O}",
    'ł' => "{\\l}",   'Ł' => "{\\L}",
    'ı' => "{\\i}",   'ȷ' => "{\\j}",
    'ß' => "{\\ss}",  'ẞ' => "{\\SS}",
    'ð' => "{\\dh}",  'Ð' => "{\\DH}",
    'þ' => "{\\th}",  'Þ' => "{\\TH}",
    'ŋ' => "{\\ng}",  'Ŋ' => "{\\NG}",
    'đ' => "{\\dj}",  'Đ' => "{\\DJ}",
    'ĳ' => "ij",      'Ĳ' => "IJ",
    'Ŀ' => "L{\\textperiodcentered}", 'ŀ' => "l{\\textperiodcentered}",
    'Ǆ' => "D{\\v Z}", 'ǅ' => "D{\\v z}", 'ǆ' => "d{\\v z}",
    'Ǉ' => "LJ", 'ǈ' => "Lj", 'ǉ' => "lj",
    'Ǌ' => "NJ", 'ǋ' => "Nj", 'ǌ' => "nj",
    'Ǳ' => "DZ", 'ǲ' => "Dz", 'ǳ' => "dz",
    'ﬀ' => "ff", 'ﬁ' => "fi", 'ﬂ' => "fl", 'ﬃ' => "ffi", 'ﬄ' => "ffl", 'ﬅ' => "st", 'ﬆ' => "st",
    ### Escaped ASCII
    '&' => "{\\&}",  '%' => "{\\%}",  '#' => "{\\#}",
    '~' => "{\\textasciitilde}", '^' => "{\\textasciicircum}",
    '\\' => "{\\textbackslash}", '|' => "{\\textbar}",
    ### Spaces and dashes
    ' ' => "~",     # no-break space
    ' ' => "\\,",   # thin space
    ' ' => "\\,",   # narrow no-break space
    '​' => "",      # zero width space
    '­' => "\\-",   # soft hyphen
    '‐' => "-",     # hyphen
    '‑' => "-",          # non-breaking hyphen
    '‒' => "--",         # figure dash
    '–' => "--",         # en dash
    '—' => "---",        # em dash
    '―' => "---",        # horizontal bar
    '−' => "{\\textminus}",
    ### Quotes
    '‘' => "`",  '’' => "'",  '‚' => "{\\quotesinglbase}", '‛' => "`",
    '“' => "``", '”' => "''", '„' => "{\\quotedblbase}",   '‟' => "``",
    '«' => "{\\guillemotleft}", '»' => "{\\guillemotright}",
    '‹' => "{\\guilsinglleft}", '›' => "{\\guilsinglright}",
    '′' => "\\ensuremath{'}", '″' => "\\ensuremath{''}",
    ### Punctuation
    '…' => "{\\ldots}", '•' => "{\\textbullet}", '·' => "{\\textperiodcentered}",
    '†' => "{\\dag}",   '‡' => "{\\ddag}",       '§' => "{\\S}", '¶' => "{\\P}",
    '¡' => "{\\textexclamdown}", '¿' => "{\\textquestiondown}",
    '¦' => "{\\textbrokenbar}",  '¬' => "{\\textlnot}",
    'ª' => "{\\textordfeminine}", 'º' => "{\\textordmasculine}",
    '´' => "{\\textasciiacute}", '¨' => "{\\textasciidieresis}", '¯' => "{\\textasciimacron}",
    ### Currency
    '€' => "{\\euro}", '£' => "{\\pounds}", '¥' => "{\\textyen}", '¢' => "{\\textcent}",
    '¤' => "{\\textcurrency}", 'ƒ' => "{\\textflorin}", '₩' => "{\\textwon}", '₦' => "{\\textnaira}", '₱' => "{\\textpeso}",
    ### Symbols
    '©' => "{\\copyright}", '®' => "{\\textregistered}", '™' => "{\\texttrademark}",
    '℗' => "{\\textcircledP}", '№' => "{\\textnumero}", '℮' => "{\\textestimated}",
    '°' => "{\\textdegree}", '∘' => "{\\textdegree}", '℃' => "{\\textcelsius}",
    '‰' => "{\\textperthousand}", '‱' => "{\\textpertenthousand}",
    '±' => "{\\textpm}", '×' => "{\\texttimes}", '÷' => "{\\textdiv}",
    '√' => "{\\textsurd}", '¼' => "{\\textonequarter}", '½' => "{\\textonehalf}",
    '¾' => "{\\textthreequarters}",
    '\u00B5' => "{\\textmu}",  # micro sign
    '\u2126' => "{\\textohm}", # ohm sign
    '\u212B' => "{\\AA}",      # angstrom sign
    '←' => "{\\textleftarrow}", '→' => "{\\textrightarrow}",
    '↑' => "{\\textuparrow}",   '↓' => "{\\textdownarrow}",
    '≤' => "\\ensuremath{\\leq}", '≥' => "\\ensuremath{\\geq}", '≠' => "\\ensuremath{\\neq}",
    '≈' => "\\ensuremath{\\approx}", '∞' => "\\ensuremath{\\infty}", '∼' => "\\ensuremath{\\sim}",
    '∝' => "\\ensuremath{\\propto}", '∂' => "\\ensuremath{\\partial}", '∇' => "\\ensuremath{\\nabla}",
    '∑' => "\\ensuremath{\\sum}", '∏' => "\\ensuremath{\\prod}", '∫' => "\\ensuremath{\\int}",
    '⋅' => "\\ensuremath{\\cdot}", 'ℏ' => "\\ensuremath{\\hbar}",
)

### Greek (textgreek package)
const GREEK = ["alpha","beta","gamma","delta","epsilon","zeta","eta","theta","iota","kappa",
               "lambda","mu","nu","xi","omicron","pi","rho","finalsigma","sigma","tau","upsilon",
               "phi","chi","psi","omega"]
for (k,name) in enumerate(GREEK)
    SPECIAL['α'+(k-1)] = "{\\text$name}"                 # α ... ω (ς at the position of finalsigma)
    name == "finalsigma" && continue                      # no upper-case final sigma (U+03A2 unassigned)
    SPECIAL['Α'+(k-1)] = "{\\text$(uppercasefirst(name))}" # Α ... Ω
end

### Super- and subscripts
for (i,d) in enumerate("⁰¹²³⁴⁵⁶⁷⁸⁹")
    SPECIAL[d] = "\\textsuperscript{$(i-1)}"
end
for (i,d) in enumerate("₀₁₂₃₄₅₆₇₈₉")
    SPECIAL[d] = "\\textsubscript{$(i-1)}"
end
merge!(SPECIAL, Dict('⁺' => "\\textsuperscript{+}", '⁻' => "\\textsuperscript{-}",
                     '₊' => "\\textsubscript{+}",   '₋' => "\\textsubscript{-}",
                     'ⁿ' => "\\textsuperscript{n}", 'ⁱ' => "\\textsuperscript{i}"))

### Plain ASCII characters that are passed through unchanged
const PASSTHROUGH = Set("?!+-*=.;:,()[]_@/<>{}\$'\"`")


function text2tex(c::Char)
    (isascii(c) && isletter(c)) && return c
    isdigit(c) && return c
    c in PASSTHROUGH && return c
    haskey(SPECIAL, c) && return SPECIAL[c]
    isspace(c) && return c
    s = accented2tex(c)
    s === nothing || return s
    error("Unknown char: '$c'")
end

### Use the canonical Unicode decomposition (letter + one combining mark) to build the LaTeX accent.
### Handles e.g. é, ŕ, ǎ, ő, ų, ṭ. Letters with several stacked accents (ế, ǘ, ậ) are not supported.
function accented2tex(c::Char)
    chars = collect(Base.Unicode.normalize(string(c), :NFD))
    length(chars) == 2 || return nothing
    base, mark = chars
    haskey(ACCENTS, mark) || return nothing
    cmd, isletteraccent = ACCENTS[mark]
    if base in ('i','j') && !(mark in BELOW_ACCENTS)
        tex = "\\" * base  # dotless i/j under accents above the letter
    elseif isascii(base) && isletter(base)
        tex = string(base)
    else
        tex = try string(text2tex(base)) catch; return nothing end
    end
    return "{\\" * cmd * (isletteraccent ? " " : "") * tex * "}"
end

end
