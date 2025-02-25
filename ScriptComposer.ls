
  ScriptComposer = do ->

    { fail } = Wsh
    { read-textfile-lines } = TextFile
    { map-items, first-item, drop-first } = NativeArray
    { lf, trim } = NativeString
    { get-absolute-path } = FileSystem

    { indent, livescript, comment } = Jsc

    #

    build-namespaces-tree = (dependencies) ->

      namespaces-tree = {}

      for dependency in dependencies

        { qualified-namespace } = dependency

        if (trim qualified-namespace) is ''
          continue

        namespaces = qualified-namespace / '.'

        current-level = namespaces-tree

        for namespace in namespaces

          if not current-level[namespace]?
            current-level[namespace] = {}

          current-level = current-level[namespace]

      namespaces-tree

    #

    compose-namespace-node-lines = (node, current-path = '') ->

      lines = []

      for namespace, children of node

        full-path = if current-path then "#current-path.#namespace" else namespace

        line = if current-path

          "#full-path = #full-path || {} ;"

        else

          "var #full-path = {} ;"

        lines ++= indent 2, line
        lines ++= compose-namespace-node-lines children, full-path

      lines

    compose-namespaces-lines = (dependencies) ->

      namespaces-tree = build-namespaces-tree dependencies

      lines = []
      seen = {}

      for line in compose-namespace-node-lines namespaces-tree

        unless seen[line]

          seen[line] = yes
          lines ++= line

      [ indent 2, comment "Namespaces" ] ++ lines

    #

    compose-dependency-lines = (dependency) ->

      { qualified-dependency-name, filepath, source } = dependency

      lines =

        * indent 2, comment "Dependency #qualified-dependency-name"
          indent 2, comment "(#filepath)"

          indent 2, "#qualified-dependency-name = do ->"

      lines ++ source

    #

    compose-dependencies-lines = (references) ->

      dependencies = DependencyManager.resolve-dependencies-references references

      namespaces-lines = compose-namespaces-lines dependencies

      dependencies-lines = []

      for dependency in dependencies

        dependencies-lines ++= compose-dependency-lines dependency

      namespaces-lines ++ dependencies-lines

    #

    compose-references-lines = (references) ->

      lines = []

      for ,reference of references

        { dependency-members, dependency-name-metadata } = reference
        { qualified-dependency-name } = dependency-name-metadata

        lines ++= indent 2, "{ #{ dependency-members * ', ' } } = #qualified-dependency-name ;"

      lines

    #

    compose-main-script-lines = (filepath, source, references) ->

      script-header =

        * indent 2, comment "Script #filepath"
          indent 2, comment "(#{ get-absolute-path filepath })"

      references-lines = compose-references-lines references

      script-header ++ references-lines ++ map-items source, -> indent 2, it

    #

    compose-script-lines = (filepath) ->

      try script-lines = read-textfile-lines filepath
      catch => fail "Unable to read content of file '#filepath'.#lf#{ e.message }."

      { references, source } = ScriptParser.parse-script-lines script-lines

      dependencies-lines = compose-dependencies-lines references

      [ livescript ] ++ dependencies-lines ++ compose-main-script-lines filepath, source, references

    {
      compose-script-lines
    }