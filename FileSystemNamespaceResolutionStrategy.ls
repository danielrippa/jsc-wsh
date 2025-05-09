
  FileSystemNamespaceResolutionStrategy = do ->

    { build-path } = FileSystem

    resolve-filesystem-namespace-path = (root-folderpath, qualified-namespace) ->

      build-path [ root-folderpath ] ++ qualified-namespace / '.'

    #

    create-filesystem-namespace-resolution-strategy = (root-filepath) ->

      do ->

        filesystem-namespaces = {}

        add-namespace = (qualified-namespace, folderpath) -> filesystem-namespaces[ qualified-namespace ] := folderpath

        #

        get-namespace-path: (qualified-namespace) !->

          filesystem-namespaces[ qualified-namespace ] => return .. unless .. is void

          resolve-filesystem-namespace-path root-filepath, qualified-namespace

            unless .. is void => add-namespace qualified-namespace, .. ; return ..

    {
      create-filesystem-namespace-resolution-strategy
    }
