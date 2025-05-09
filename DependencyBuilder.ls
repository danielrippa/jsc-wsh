
  DependencyBuilder = do ->

    { parse-script-lines } = ScriptParser
    { resolve-namespace-paths } = NamespacePathResolver
    { fail } = Script
    { build-path, does-file-exist } = FileSystem
    { read-text-file } = TextFile
    { string-as-lines } = NativeString

    resolve-dependency-filepath = (dependency-name-metadata) ->

      { qualified-namespace, dependency-name, qualified-dependency-name } = dependency-name-metadata

      resolved-folderpaths = resolve-namespace-paths qualified-namespace

      fail [ "Unable to resolve paths for qualified namespace '#qualified-namespace'" ], 6 \
        if resolved-folderpaths.length is 0

      for folderpath in resolved-folderpaths

        build-path [ folderpath, "#dependency-name.ls" ]

          return .. if does-file-exist ..

      fail [ "Unable to locate dependency '#qualified-dependency-name' in #{ resolved-folderpaths * ',' }" ], 7

    build-dependency = (dependency-name-metadata) ->

      { qualified-dependency-name } = dependency-name-metadata

      filepath = resolve-dependency-filepath dependency-name-metadata

      { dependencies-references, livescript-lines } =

        filepath |> read-text-file |> string-as-lines

          |> parse-script-lines

      dependency-name-metadata with { dependencies-references, livescript-lines, filepath }

    {
      build-dependency
    }