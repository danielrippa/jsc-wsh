
  TextFile = do ->

    { file-system } = FileSystem
    { must-be } = NativeType

    io-mode = reading: 1

    text-stream = (filepath, mode) -> file-system!OpenTextFile (filepath `must-be` 'String'), (mode `must-be` 'Number')

    read-text-file = (filepath) -> (text-stream filepath, io-mode.reading) => content = ..ReadAll! ; ..Close! ; return content

    {
      io-mode,
      text-stream,
      read-text-file
    }