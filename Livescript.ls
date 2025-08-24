
  Livescript = do ->

    { string-contains: contains, trim, single-quote, indent-string } = NativeString
    { first-array-item, last-array-item, drop-last, map-array-items } = NativeArray
    { throw-error } = NativeError
    { must-be } = NativeType

    dependency-keyword = ' dependency '

    #

    first-middle-and-last = ->

      chars = (it `must-be` 'String') / ''

      * first-array-item chars
        it.slice 1, -1
        last-array-item  chars

    #

    comment = -> "``// #it``"

    comment-lines = -> map-array-items it, comment

    indent-lines = (level, lines) -> map-array-items lines, -> indent-string (level `must-be` 'Number'), it

    #

    is-do-line = ->

      if it `contains` 'do'
        if it `contains` '->'

          [ first, last ] = (trim it) / ' '

          first = trim first
          last  = trim last

          if first is 'do'
            if last is '->'

              return yes

      no

    is-comment-line = ->

      chars = (trim it) / ''
      (first-array-item chars) is '#'

    #

    is-reference-line = -> it `contains` dependency-keyword

    #

    invalid-dependency-syntax = (line, index) ->

      throw-error "Invalid dependency reference syntax at line #index '#line'"

    #

    dependency-literal-as-qualified-dependency-name = (dependency-literal, line, index) ->

      [ first, middle, last ] = first-middle-and-last trim dependency-literal

      invalid-dependency-syntax line, index \
        unless first is single-quote and last is single-quote

      trim middle

    #

    parse-qualified-dependency-name = ->

      line = trim it

      [ qualified-namespace, dependency-name ] = if line `contains` '.'

        namespaces = line / '.'
        [ (drop-last namespaces |> (* '.')), (last-array-item namespaces) ]

      else

        [ '', line ]

      { qualified-namespace, dependency-name, qualified-dependency-name: line }

    #

    parse-members-literal = (members-literal, line, index) ->

      invalid-dependency-syntax line, index \
        unless members-literal `contains` '='

      index = members-literal.index-of '='
      members-literal = trim members-literal.slice 0, index

      [ first, middle, last ] = first-middle-and-last members-literal

      invalid-dependency-syntax line, index \
        unless first is '{' and last is '}'

      [ (trim member) for member in middle / ',' ]

    parse-reference-line = (line, index) ->

      [ members-literal, dependency-literal ] = line / "#dependency-keyword"

      dependency-name-metadata =

        dependency-literal-as-qualified-dependency-name dependency-literal, line, index
        |> parse-qualified-dependency-name

      dependency-members = parse-members-literal members-literal, line, index

      { dependency-name-metadata, dependency-members }

    {
      dependency-keyword,
      is-do-line,
      is-comment-line,
      is-reference-line,
      parse-reference-line,
      comment, comment-lines,
      indent-lines
    }