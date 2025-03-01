
  DependencyBuilder = do ->

    { fail } = Wsh
    { file-exists, folder-exists } = FileSystem
    { read-textfile-lines } = TextFile
    { trim } = NativeString

    { is-do-line, as-filepath } = Jsc

    #

    invalid-dependency-syntax = (dependency-lines) ->

      invalid = yes

      for line in dependency-lines

        if (trim line) is ''
          continue

        if is-do-line line
          invalid = no
          break

      invalid

    #

    build-dependency = (dependency-name-metadata) ->

      { qualified-namespace, qualified-dependency-name, dependency-name } = dependency-name-metadata

      WScript.Echo 'dependency-name:', "[#dependency-name]"

      namespace-path = NamespacePathResolver.resolve-namespace-path qualified-namespace, dependency-name

      if namespace-path is void

        fail "Unable to resolve dependency '#qualified-dependency-name'."

      filepath = as-filepath namespace-path, dependency-name

      try dependency-lines = read-textfile-lines filepath
      catch => fail ""

      if invalid-dependency-syntax dependency-lines

        fail do

          * "Syntax error in dependency '#qualified-dependency-name'."
            "(#filepath)"
            "Dependency source must start with 'do ->'"

      { references, source } = ScriptParser.parse-script-lines dependency-lines

      dependency-name-metadata with { references, source, filepath }

    {
      build-dependency
    }