
  DependencyManager = do ->

    { lcase } = NativeString

    #

    resolved-dependencies = {}
    dependencies = []

    add-dependency = (dependency) !->

      dependency-name = lcase dependency.qualified-dependency-name

      resolved-dependencies[dependency-name] := dependency
      dependencies.push dependency

    #

    resolve-reference = (parent-reference) ->

      { dependency-name-metadata: parent } = parent-reference

      parent-dependency = resolved-dependencies[ lcase parent.qualified-dependency-name ]

      if parent-dependency is void

        parent-dependency = DependencyBuilder.build-dependency parent

      for , child-reference of parent-dependency.references

        { dependency-name-metadata: child } = child-reference

        child-dependency = resolved-dependencies[ lcase child.qualified-dependency-name ]

        if child-dependency is void

          resolve-reference child-reference

      add-dependency parent-dependency

    #

    resolve-dependencies-references = (references) ->

      for ,reference of references

        resolve-reference reference

      dependencies

    {
      resolve-dependencies-references
    }