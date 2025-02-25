
  NamespacePathResolver = do ->

    { file-exists } = FileSystem
    { get-current-folder } = Shell
    { read-objectfile } = ObjectFile

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

      namespace-path = ([ current-folder ] ++ namespaces) * '\\'

      filesystem-namespaces[ qualified-namespace ] := namespace-path

      namespace-path

    #

    get-filesystem-namespace-path = (qualified-namespace) ->

      namespace-path = filesystem-namespaces[qualified-namespace]

      if namespace-path isnt void
        return namespace-path

      resolve-filesystem-namespace-path qualified-namespace

    #

    resolve-configuration-namespace-path = (qualified-namespace) ->

      root-configuration-namespace = configuration-namespaces['.']

      if root-configuration-namespace isnt void

        namespaces = qualified-namespace / '.'

        ([ root-configuration-namespace ] ++ namespaces) * '\\'

    #

    get-configuration-namespace-path = (qualified-namespace) ->

      namespace-path = configuration-namespaces[qualified-namespace]

      if namespace-path isnt void
        return namespace-path

      resolve-configuration-namespace-path qualified-namespace

    #

    resolve-namespace-path = (qualified-namespace) ->

      if qualified-namespace is ''
        return current-folder

      namespace-path = get-configuration-namespace-path qualified-namespace

      if namespace-path is void

        namespace-path = get-filesystem-namespace-path qualified-namespace

      namespace-path

    {
      resolve-namespace-path
    }