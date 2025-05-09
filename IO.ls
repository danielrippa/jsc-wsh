
  IO = do ->

    [ stdout, stderr ] = do ->

      stream = (stream-name) -> !-> for arg in arguments => WScript[stream-name].Write arg

      [ (stream name) for name in <[ StdOut StdErr ]> ]

    {
      stdout, stderr
    }