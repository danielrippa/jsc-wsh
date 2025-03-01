
  NamespacePathResolver = do ->

    { file-exists, folder-exists, path-separator } = FileSystem
    { get-current-folder } = Shell
    { read-objectfile } = ObjectFile
    { as-filepath } = Jsc

    current-folder = get-current-folder!

    configuration-namespaces = do ->

      filename = 'namespaces.conf'

      if not file-exists filename => return {}

      read-objectfile filename

    #

    filesystem-namespaces = {}

    #

    resolve-filesystem-namespace-path = (qualified-namespace) ->

      namespaces = qualified-namespace / '.'

      namespace-path = ([ current-folder ] ++ namespaces) * "#path-separator"

      filesystem-namespaces[ qualified-namespace ] := namespace-path

      namespace-path

    #

    get-filesystem-namespace-paths = (qualified-namespace) ->

      paths = []

      namespace-path = filesystem-namespaces[qualified-namespace]

      if namespace-path isnt void
        paths.push namespace-path

      namespace-path = resolve-filesystem-namespace-path qualified-namespace

      if namespace-path isnt void
        paths.push namespace-path

      paths

    #

    resolve-configuration-namespace-path = (qualified-namespace) ->

      root-configuration-namespace = configuration-namespaces['.']

      namespaces = qualified-namespace / '.'

      if root-configuration-namespace isnt void

        ([ root-configuration-namespace ] ++ namespaces) * '\\'

    #

    get-configuration-namespace-paths = (qualified-namespace) ->

      paths = []

      namespace-path = configuration-namespaces[qualified-namespace]

      if namespace-path isnt void
        paths.push namespace-path

      namespace-path = resolve-configuration-namespace-path qualified-namespace
      if namespace-path isnt void
        paths.push namespace-path

      paths

    #

    namespace-path-resolution-strategies =

      * get-filesystem-namespace-paths
        get-configuration-namespace-paths

    resolve-namespace-path = (qualified-namespace, dependency-name) ->

      for get-namespace-paths in namespace-path-resolution-strategies

        for namespace-path in get-namespace-paths qualified-namespace

          if namespace-path isnt void

            if folder-exists namespace-path

              filepath = namespace-path |> as-filepath _ , dependency-name

              WScript.Echo namespace-path, filepath



              if file-exists filepath
                return namespace-path

    {
      resolve-namespace-path
    }