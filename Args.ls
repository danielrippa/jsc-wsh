
  Args = do ->

    WScript.Arguments.Unnamed

      arg  = -> ..Item it
      argc = ..Count

    argv = [ (arg index) for index til argc ]

    {
      argc, argv
    }