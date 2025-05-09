
  Args = do ->

    { must-be } = NativeType

    WScript.Arguments.Unnamed

      argc = ..Count
      arg  = -> ..Item (it `must-be` 'Number')

    argv = [ (arg index) for index til argc ]

    {
      arg, argc, argv
    }