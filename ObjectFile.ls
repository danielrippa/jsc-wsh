
  ObjectFile = do ->

    { object-from-pairs } = NativeObject
    { read-text-file } = TextFile
    { trim, string-as-lines, string-contains: contains } = NativeString
    { map-array-items, filter-array-items } = NativeArray

    lines-as-member-pairs = (lines) ->

      lines

        |> map-array-items _ , (line) ->

          line = trim line

          index = line.index-of ' '

          if index is -1

            [ line, void ]

          else

            key = line.slice 0, index ; value = line.slice index + 1

            [ key, value ]

    is-comment-line = -> i

    read-object-file = (filepath) ->

      filepath

        |> read-text-file
        |> string-as-lines
        |> filter-array-items _ , -> (trim it)      isnt ''
        |> filter-array-items _ , -> (it.char-at 0) isnt '#'
        |> lines-as-member-pairs
        |> object-from-pairs

    {
      read-object-file
    }