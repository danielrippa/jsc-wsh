
  NativeString = do ->

    char = -> String.from-char-code it

    cr = '\r' ; lf = '\n' ; crlf = "#cr#lf"

    regex = -> new RegExp it, 'g'

    record = char 30

    replace-crlf = (.replace (regex crlf), record)
    replace-lf   = (.replace (regex lf),   record)

    string-as-records = -> it |> replace-crlf |> replace-lf

    records-as-array = (.split record)

    text-as-lines = -> it |> string-as-records |> records-as-array

    #

    trim-regex = /^\s+|\s+$/g

    trim = (.replace trim-regex, '')

    #

    lcase = (.to-lower-case!)

    #

    repeat-string = (string, n) -> Array n + 1 .join string

    {
      lf,
      text-as-lines,
      trim,
      lcase,
      repeat-string
    }