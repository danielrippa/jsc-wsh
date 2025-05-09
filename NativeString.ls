
  NativeString = do ->

    { must-be } = NativeType

    char = (char-code) -> String.from-char-code (char-code `must-be` 'Number')

    [ cr, lf, record, backward-slash ] = [ (char char-code) for char-code in [ 10 13 30 92 ] ]

    crlf = "#cr#lf"

    #

    regexp-flags = global: 'g'

    create-regexp = (expression, flag = regexp-flags.global) ->

      new RegExp (expression `must-be` 'String'), (flag `must-be` 'String')

    replace-crlf = (.replace (create-regexp crlf), record)
    replace-lf   = (.replace (create-regexp lf),   record)

    string-as-records = -> it |> replace-crlf |> replace-lf

    records-as-array = (.split record)

    string-as-lines = -> (it `must-be` 'String') |> string-as-records |> records-as-array

    #

    whitespace = "#{ backward-slash }s+"

    whitespace-at-start = "^#{ whitespace }"
    whitespace-at-end   = "#{ whitespace }$"

    trim-regexp = create-regexp "#whitespace-at-start|#whitespace-at-end"

    trim = -> (it `must-be` 'String') |> (.replace trim-regexp, '')

    #

    repeat-string = (string, times) -> Array (times `must-be` 'Number') + 1 |> (* "#string")

    #

    indent-string = (level, string) -> "#{ repeat-string ' ', level }#string"

    #

    string-contains = (haystack, needle) ->

      (haystack `must-be` 'String').index-of (needle `must-be` 'String')
        return .. isnt -1

    single-quote = "'"

    #

    lower-case = -> (it `must-be` 'String') |> (.to-lower-case!)

    {
      char,
      cr, lf, crlf, record, backward-slash,
      string-as-lines,
      trim,
      repeat-string, indent-string,
      string-contains,
      single-quote,
      lower-case
    }