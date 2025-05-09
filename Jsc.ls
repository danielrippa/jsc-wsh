
  Jsc = do ->

    { script-filepath } = Script
    { file-name } = FileSystem
    { fail } = Script
    { read-text-file } = TextFile

    usage =

      * "Usage:"
        "#{ file-name script-filepath } filepath"

    filepath-arg = (argv) ->

      switch argv

        | []  => fail [ "Missing filepath argument" ] ++ usage , 1

        else argv.0

    main-script-content = (argv) ->

      try content = read-text-file filepath-arg argv
      catch => fail [ "Unable to read main script file '#filepath'", e.message ], 2

      content

    {
      main-script-content
    }