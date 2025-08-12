
  ConfigurationNamespaceResolutionStrategy = do ->

    { read-object-file } = ObjectFile
    { does-file-exist } = FileSystem

    configuration-filename = 'namespaces.conf'

    create-configuration-namespace-resolution-strategy = (configuration-filepath) ->

      configuration-namespaces = if does-file-exist configuration-filepath

        read-object-file configuration-filepath

      else

        {}

      do ->

        get-root-configuration-filepath: -> configuration-namespaces[ '.' ]

        get-namespace-path: (qualified-namespace) ->

          if qualified-namespace isnt '.'

            configuration-namespaces[ qualified-namespace ]

    {
      create-configuration-namespace-resolution-strategy,
      configuration-filename
    }