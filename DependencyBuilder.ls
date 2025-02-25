
  DependencyBuilder = do ->

    { fail } = Wsh
    { file-exists, folder-exists } = FileSystem
    { read-textfile-lines } = TextFile
    { trim } = NativeString

    { is-do-line } = Jsc

    #

    read-dependency-lines = (filepath, qualified-dependency-name) ->

      if not file-exists filepath

        fail do

          * "Unable to read dependency '#qualified-dependency-name'."
            "File '#filepath' not found."
            "Check your 'namespaces.conf' file."

      try dependency-lines = read-textfile-lines filepath
      catch

        fail do

          * "Unable to read dependency '#qualified-dependency-name'"
            e.message
            "Check your 'namespaces.conf' file."

      dependency-lines

    #

    parse-dependency-lines = (dependency-lines, qualified-dependency-name, filepath) ->

      for line in dependency-lines

        if (trim line) is ''
          continue

        break if is-do-line line

        fail do

          * "Syntax error in dependency '#qualified-dependency-name'."
            "(#filepath)"
            "Dependency source must start with 'do ->'"

      result = ScriptParser.parse-script-lines dependency-lines

      result

    #

    build-dependency = (dependency-name-metadata) ->

      { qualified-namespace, qualified-dependency-name, dependency-name } = dependency-name-metadata

      namespace-path = NamespacePathResolver.resolve-namespace-path qualified-namespace

      if namespace-path is void

        fail do

          * "Unable to resolve path of dependency '#qualified-dependency-name'."
            "Check your 'namespaces.conf' file."

      if not folder-exists namespace-path

        fail do

          * "Unable to resolve path of dependency '#qualified-dependency-name'"
            "Folder '#namespace-path' not found."
            "Check your 'namespaces.conf' file."

      filepath = [ namespace-path, "#dependency-name.ls" ] * '\\'

      { references, source } =

        filepath

          |> read-dependency-lines _ , qualified-dependency-name
          |> parse-dependency-lines _ , qualified-dependency-name, filepath

      dependency-name-metadata with { references, source, filepath }

    {
      build-dependency
    }