module Text2Tex

export text2tex

function text2tex(stringIn::AbstractString;verbose=false,context=10::Integer)
    verbose && println("Decoding:'$stringIn'")
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
                noRight = minimum([length(stringIn)-cno,context])
                StringLeft=stringIn[(cno-noLeft):(cno-1)]
                #StringRight=stringIn[(cno+1):(cno+noRight)]
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

function BO(accentcode,letter::Char)
    return "{"*'\\'*accentcode*letter*"}"
end
function BOE(accentcode,letter::Char) ##Encapsulate
    return "{"*'\\'*accentcode*" "*letter*"}"
end


text2tex(::Missing) = ""
text2tex(n::Integer) = "$n"
text2tex(n::Real) = "$n"

function text2tex(c::Char)
    in(c,'A':'Z') && return c ### Upper case
    in(c,'a':'z') && return c ### lower case
    in(c,'0':'9') && return c ### lower case
    in(c,"?+.;,():_@/<>{}") && return c
    c == '\$' && return c

    c == 'å' && return "{\\aa}"  ###
    c == '&' && return "{\\&}"  ###
    c == '-' && return '-' ###Long dash
    c == '–' && return '-' ###Long dash
    c == '’' && return '\'' ###Fancy end-quite

    c == '€' && return "{\\euro}"
    #https://tex.stackexchange.com/tags/accents/info
    #https://tex.stackexchange.com/questions/8857/how-to-type-special-accented-letters-in-latex
    
    isspace(c) && return c # space
    ###Special characters
    c == 'ı' && return "{\\i}"
    c == 'ł' && return "{\\l}"
    c == 'ß' && return "{\\ss}"
    c == 'π' && return "{\\textpi}"
    c == 'Γ' && return "{\\textGamma}"
    ## cedilla
    c == 'ş' && return BOE('c','s')
    c == 'ç' && return BOE('c','c')
    ## check
    c == 'ğ' && return BOE('v','g')
    c == 'Š' && return BOE('v','S')
    c == 'š' && return BOE('v','s')
    c == 'Č' && return BOE('v','C')
    c == 'č' && return BOE('v','c')  
    ## umlaut
    c == 'ö' && return BO('"','o')
    c == 'ë' && return BO('"','e')
    c == 'ü' && return BO('"','u')
    c == 'ä' && return BO('"','a')
    c == 'ï' && return BO('"','i')
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


end
