
  IO = do ->

    { lf } = NativeString

    [ stdout, stderr ] = do ->

      stream = (name) -> !-> for arg in & => WScript["Std#name"].Write arg

      [ (stream name) for name in <[ Out Err ]> ]

    #

    writeln = -> stdout lf ; stdout ...
    log = -> stderr lf ; stderr ...

    {
      writeln, log,
      lf
    }