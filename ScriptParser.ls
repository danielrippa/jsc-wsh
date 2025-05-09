
  ScriptParser = do ->

    { is-do-line, is-comment-line, is-reference-line, comment, parse-reference-line } = Livescript
    { indent-string } = NativeString

    parse-script-lines = (lines) ->

      references = {} ; livescript = []

      add-reference = (reference) ->

        { dependency-name-metadata: { qualified-dependency-name }, dependency-members } = reference

        if references[ qualified-dependency-name ] is void

          references[ qualified-dependency-name ] := reference

        else

          references[ qualified-dependency-name ].dependency-members ++= dependency-members

      [ prelude, code ] = <[ prelude code ]>

      parser-state = prelude

      for line, index in lines

        switch parser-state

          | prelude =>

            continue if (trim line) is ''

            match line

              | is-do-line =>
              | is-comment-line => livescript ++= indent-string 2, comment trim line
              | is-reference-line => add-reference parse-reference-line line, index

              else parser-state = code ; livescript ++= line

          | code => livescript ++= line

      { dependencies-references: references, livescript-lines: livescript }

    {
      parse-script-lines
    }