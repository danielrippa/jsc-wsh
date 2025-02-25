
  ObjectFile = do ->

    { read-textfile-lines } = TextFile
    { trim } = NativeString

    read-objectfile = (filepath) ->

      object = {}

      for line in read-textfile-lines filepath

        trimmed = trim line

        if trimmed is ''
          continue

        if (trimmed.char-at 0) is '#'
          continue

        index = trimmed.index-of ' '

        if index is -1

          object[trimmed] = void

        else

          key = trimmed.slice 0, index
          value = trimmed.slice index + 1

          object[key] = value

      object

    {
      read-objectfile
    }