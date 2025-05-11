
  DependenciesComposer = do ->

    { object-member-values } = NativeObject
    { map-array-items: map, fold-array } = NativeArray
    { resolve-dependencies-references } = DependencyManager
    { value-as-string } = NativeType
    { comment } = Livescript
    { indent-string } = NativeString

    indent2 = -> indent-string 2, it

    compose-dependencies-references = (references) ->

      references

        |> object-member-values
        |> map _ , ({ dependency-members, dependency-name-metadata: { qualified-dependency-name } }) ->

          "{ #{ dependency-members * ', ' } } = #qualified-dependency-name ;"

    #

    add-namespaces = (current, namespaces, index = 0) ->

      if index >= namespaces.length

        current

      else

        namespace = namespaces[ index ]
        current[ namespace ] = current[ namespace ] ? {}

        add-namespaces current[ namespace ], namespaces, index + 1

    #

    build-namespaces-tree = (dependencies) ->

      namespaces-tree = {}

      for { qualified-namespace } in dependencies

        continue if qualified-namespace is ''

        add-namespaces namespaces-tree, (qualified-namespace / '.')

      namespaces-tree

    #

    compose-namespace-node-lines = (node, current-path = '') ->

      lines = []

      for namespace, children of node

        full-path = if current-path then "#current-path.#namespace" else namespace

        lines ++= indent2 "#full-path = #{ if current-path then "#full-path || " else '' }{} ;"
        lines ++= compose-namespace-node-lines children, full-path

      lines

    #

    compose-namespaces-lines = (dependencies) ->

      lines = [] ; seen = {}

      for line in compose-namespace-node-lines build-namespaces-tree dependencies

        unless seen[line]

          seen[line] = yes
          lines ++= line

      #

      [ indent2 comment "Namespaces" ] |> (++ lines)

    #

    compose-dependency-lines = (dependency) ->

      { qualified-dependency-name, filepath, dependencies-references, livescript-lines } = dependency

      references-lines = compose-dependencies-references dependencies-references |> map _ , indent2 |> map _ , indent2

      [ "Dependency #qualified-dependency-name", "(#filepath)" ] |> map _ , comment

      |> (++ "#qualified-dependency-name = do ->") |> map _ , indent2

      |> (++ references-lines)
      |> (++ livescript-lines)

    #

    compose-dependencies-lines = (dependencies) ->

      fold-array dependencies, [], (lines, dependency) -> lines ++ compose-dependency-lines dependency

    #

    compose-dependencies-source = (dependencies-references) ->

      dependencies = resolve-dependencies-references dependencies-references

      (compose-namespaces-lines dependencies) |> (++ compose-dependencies-lines dependencies)

    {
      compose-dependencies-references,
      compose-dependencies-source
    }