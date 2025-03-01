
  ScriptParser = do ->

    { fail } = Wsh
    { read-textfile-lines } = TextFile
    { trim } = NativeString
    { first-item, last-item, drop-last } = NativeArray

    { dependency-keyword, indent, comment, is-comment-line, is-reference-line, is-do-line } = Jsc

    #

    parse-members-line = (line) ->

      index = line.index-of '='

      throw new Error "Invalid dependency syntax.#{lf}Line '#line' is missing '=' character." \
        if index is -1

      members = []

      line = trim line.slice 0, index

      first = line.char-at 0
      last  = line.char-at (line.length - 1)

      brackets-ok = first is '{' and last is '}'

      throw new Error "" \
        unless brackets-ok

      line = trim line.slice 1, -1

      [ (trim member) for member in line / ',' ]

    #

    parse-qualified-dependency-name = (line) ->

      line = trim line

      qualified-dependency-name = line

      if (line.index-of '.') is -1

        qualified-namespace = ''
        dependency-name = line

      else

        namespaces = line / '.'

        dependency-name = last-item namespaces

        namespaces = drop-last namespaces

        qualified-namespace = namespaces * '.'

      { qualified-namespace, dependency-name, qualified-dependency-name }

    #

    parse-reference-line = (line) ->

      WScript.Echo "reference-line: [#line]"

      [ members-line, dependency-name ] = line.split dependency-keyword

      dependency-name-metadata = parse-qualified-dependency-name dependency-name

      dependency-members = parse-members-line members-line

      { dependency-name-metadata, dependency-members }

    #

    parse-script-lines = (lines) ->

      [ prelude, code ] = <[ prelude code ]>

      references = {} ; source = []

      parser-state = prelude

      for line, index in lines

        switch parser-state

          | prelude =>

            continue if (trim line) is ''

            match line

              | is-do-line =>

                # source ++= line

              | is-comment-line =>

                source ++= indent 2, comment trim line

              | is-reference-line =>

                reference = parse-reference-line line

                { dependency-name-metadata, dependency-members } = reference
                { qualified-dependency-name } = dependency-name-metadata

                existing-reference = references[ qualified-dependency-name ]

                if existing-reference is void

                  references[ qualified-dependency-name ] = reference

                else

                  references[ qualified-dependency-name ].dependency-members ++= dependency-members

              else

                parser-state = code
                source ++= line

          | code =>

            source ++= line

      { references, source }

    {
      parse-script-lines
    }