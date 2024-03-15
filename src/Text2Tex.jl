
using Test

function Text2Tex(stringIn::AbstractString)
    println("Decoding:'$stringIn'")    
    charString=join([Text2Tex(char) for char in stringIn])
    ##Search for <sub>
    charString = replace(charString, "<sub>"=>"\$_{")
    #println("Replaced:'$string'")
    charString = replace(charString, "</sub>"=>"}\$")
    #println("Replaced:'$string'")
    charString = replace(charString, "<br>"=>"\\\\")
    return charString
end

function BO(accentcode,letter::Char)
    return "{"*'\\'*accentcode*letter*"}"
end

Text2Tex(::Missing) = ""
function Text2Tex(c::Char)
    in(c,'A':'Z') && return c ### Upper case
    in(c,'a':'z') && return c ### lower case
    in(c,'0':'9') && return c ### lower case
    in(c,".;,():_@/<>{}") && return c
    c == '\$' && return c
    c == '&' && return "\\&"  ###
    c == '-' && return '-' ###Long dash
    c == '–' && return '-' ###Long dash
    c == '’' && return '\'' ###Fancy end-quite

    c == '€' && return "{\\euro}"
    #https://tex.stackexchange.com/tags/accents/info
    
    isspace(c) && return c # space
    ###Special characters
    c == 'ı' && return 'i'  ###FIXME
    c == 'ł' && return 'l'  ###FIXME
    c == 'ß' && return BO('s','s')
    ## cedilla
    c == 'ş' && return 's' ###FIXME return BO('c','s')
    c == 'ç' && return 'c' ###FIXME BO('c','c')
    ## check
    c == 'ğ' && return "g" ###FIXME '\\'*'v'*'g'
    c == 'Š' && return "S" ###FIXME '\\'*'v'*'S'
    c == 'š' && return "s" ###FIXME '\\'*'v'*'s'
    c == 'Č' && return "C" ###FIXME '\\'*'v'*'s'
    ## umlaut
    c == 'ö' && return BO('"','o')
    c == 'ë' && return BO('"','e')
    c == 'ü' && return BO('"','u')
    ## grave accent
    c == 'è' && return BO("\`",'e')
    c == 'à' && return BO("\`",'a')
    ## acute accent
    c == 'á' && return BO("'",'a')
    c == 'ń' && return BO("'",'n')
    c == 'ó' && return BO("'",'o')
    c == 'í' && return BO("'",'i')
    c == 'ź' && return BO("'",'z')
    c == 'é' && return BO("'",'e')
    c == 'ú' && return BO("'",'u')
    c == 'ć' && return BO("'",'c')
    ## tilde
    c == 'ñ' && return '\\'*'~'*'n'  ###FIXME
    c == 'ã' && return '\\'*'~'*'a'  ###FIXME
    error("Unknown char: '$c'")
end



@test  Text2Tex("Wte<sub>2</sub>B") == "Wte\$_{2}\$B"
@test  Text2Tex("Wte<sub>1</sub>") == "Wte\$_{1}\$"
@test  Text2Tex("G<sub>10</sub>A") == "G\$_{10}\$A"
