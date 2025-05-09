
  Script = do ->

    { must-be, value-type-tag } = NativeType
    { stderr } = IO
    { each-array-item } = NativeArray
    { crlf } = NativeString

    WScript

      script-filepath = ..ScriptFullName

      exit = (errorlevel = 0) -> ..Quit (errorlevel `must-be` 'Number')

    #

    value-as-array = (value) ->

      switch value-type-tag value

        | 'Array' => value

        else [ value ]

    #

    fail = (message, errorlevel = 1) ->

      each-array-item (value-as-array message), -> stderr it, crlf
      exit (errorlevel `must-be` 'Number')

    {
      script-filepath,
      exit, fail
    }