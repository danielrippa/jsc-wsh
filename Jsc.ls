
  Jsc = do ->

    { get-name, path-separator } = FileSystem
    { script-name } = Wsh
    { repeat-string, trim } = NativeString
    { first-item } = NativeArray

    dependency-keyword = ' dependency '

    livescript = ":livescript(bare='true' header='\\n')"

    get-usage = ->

      * "Usage:"
        "#{ get-name script-name } filepath"

    indent = (level, string) -> "#{ repeat-string ' ', level }#string"

    comment = -> "``// #it``"

    is-comment-line = (line) ->

      chars = (trim line) / ''
      (first-item chars) is '#'

    is-reference-line = (line) ->

      (line.index-of dependency-keyword) isnt -1

    is-do-line = (line) ->

      line = trim line

      return no if line is ''

      if (line.index-of 'do') isnt -1
        if (line.index-of '->') isnt -1

          [ first, last ] = line.split ' '

          first = trim first
          last  = trim last

          if first is 'do'
            if last is '->'

              return yes

    as-filepath = (namespace, name) -> "#namespace#path-separator#name.ls"

    {
      get-usage,
      livescript,
      indent,
      dependency-keyword,
      comment,
      is-comment-line, is-reference-line, is-do-line,
      as-filepath
    }