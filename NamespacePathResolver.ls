
  NamespacePathResolver = do ->

    { does-folder-exist, does-file-exist, build-path, absolute-path, parent-folderpath, get-current-folderpath } = FileSystem
    { script-filepath, fail } = Script

    { create-configuration-namespace-resolution-strategy: create-configuration-strategy, configuration-filename } = ConfigurationNamespaceResolutionStrategy
    { create-filesystem-namespace-resolution-strategy: create-filesystem-strategy } = FileSystemNamespaceResolutionStrategy

    # estamos asumiendo que la compilacion se podria lanzar desde una folder distinta de donde reside el script que se quiere compilar
    # es posible que sea porque en estas carpetas haya versiones que se quieren usar que sean distintas de donde actualmente reside el script
    # por lo tanto, se buscara resolver los paths primero a partir de current-folder,
    # luego a partir de la carpeta donde efectivamente esta el script
    # es posible que se quieran usar versiones especificas y para eso se usara el archivo de configuracion
    # el archivo de configuracion es opcional
    # donde se puede apuntar namespaces especificos a carpetas especificas (en esta version, seran paths absolutos)
    # como se asume que cada tanto se cristalizaran versiones del framework en carpetas especificas,
    # se ofrece la oportunidad de especificar un path absoluto que apunte a esa version especifica del framework
    # mediante el namespace especial '.' en el archivo de configuracion
    # la declaracion del namespace especial '.' es opcional

    namespace-path-getters = do ->

      current-folderpath = get-current-folderpath!
      script-folderpath = parent-folderpath script-filepath

      #

      configuration-strategy = null

      configuration-filepath = build-path [ script-folderpath, configuration-filename ]

      if does-file-exist configuration-filepath

        configuration-strategy = create-configuration-strategy configuration-filepath

      #

      getters = []

      add-strategy-getter = (strategy) -> getters.push strategy.get-namespace-path

      #

      add-strategy-getter create-filesystem-strategy script-folderpath

      if script-folderpath isnt current-folderpath

        add-strategy-getter create-filesystem-strategy current-folderpath

      if configuration-strategy?

        root-configuration-filepath = configuration-strategy.get-root-configuration-filepath!

        if root-configuration-filepath isnt void

          add-strategy-getter create-filesystem-strategy root-configuration-filepath

        add-strategy-getter configuration-strategy

      getters

    #

    resolve-namespace-paths = (qualified-namespace, dependency-name) ->

      paths = []

      for get-namespace-path, index in namespace-path-getters

        namespace-path = get-namespace-path qualified-namespace

        if namespace-path isnt void

          absolute-namespace-path = absolute-path namespace-path

          if does-folder-exist absolute-namespace-path

            paths.push absolute-namespace-path

      paths

    {
      resolve-namespace-paths
    }
