
  NativeFunction = do ->

    { text-as-lines, trim } = NativeString

    code-of = (fn) ->

      code = fn.to-string!

        code-start = ..index-of '{'
        code-end   = ..last-index-of '}'

      code

        |> (.slice code-start + 1, code-end - 1)
        |> text-as-lines
        |> (* ' ')
        |> trim

    {
      code-of
    }