
  TextFile = do ->

    { file-system } = FileSystem
    { text-as-lines } = NativeString

    io-mode = reading: 1

    text-stream = (filepath) -> file-system!OpenTextFile filepath, io-mode.reading

    read-textfile = (filepath) ->

      (text-stream filepath) => content = ..ReadAll! ; ..Close!

      content

    read-textfile-lines = -> read-textfile it |> text-as-lines

    {
      read-textfile-lines
    }