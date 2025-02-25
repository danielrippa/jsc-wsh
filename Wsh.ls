
  Wsh = do ->

    { lf } = NativeString
    { log } = IO

    #

    WScript

      script-name = ..ScriptName

      exit = (errorlevel = 0) !-> ..Quit errorlevel

    #

    text = -> if (typeof! it) is 'Array' then it * "#lf" else it

    #

    fail = (message, errorlevel = 1) !->

      if message isnt void => log text message
      exit errorlevel

    {
      script-name,
      exit, fail
    }