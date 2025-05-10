
  DependencyManager = do ->

    { each-array-item } = NativeArray
    { each-object-member } = NativeObject
    { lower-case } = NativeString
    { build-dependency } = DependencyBuilder
    { value-as-string, value-type-tag } = NativeType

    resolved-dependencies = {} ; dependencies = []

    add-dependency = (dependency) ->

      { qualified-dependency-name } = dependency

      resolved-dependencies[ lower-case qualified-dependency-name ] := dependency
      dependencies.push dependency

    #

    resolve-dependency-reference = (parent-reference) ->

      { dependency-name-metadata: parent-metadata } = parent-reference
      { qualified-dependency-name: parent-dependency-name } = parent-metadata

      dependency-key = lower-case parent-dependency-name

      if resolved-dependencies[ dependency-key ] is void
        add-dependency build-dependency parent-metadata

      { dependencies-references } = resolved-dependencies[ dependency-key ]

      each-object-member dependencies-references, (key, child-reference) ->

        { dependency-name-metadata: { qualified-dependency-name } } = child-reference

        child-dependency = resolved-dependencies[ lower-case qualified-dependency-name ]
        if child-dependency is void

          resolve-dependency-reference child-reference

    #

    resolve-dependencies-references = (references) ->

      each-object-member references, (key, value) -> resolve-dependency-reference value

      dependencies

    {
      resolve-dependencies-references
    }