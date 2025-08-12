
  DependencyManager = do ->

    { each-array-item } = NativeArray
    { each-object-member } = NativeObject
    { lower-case } = NativeString
    { build-dependency } = DependencyBuilder
    { value-as-string, value-type-tag } = NativeType

    resolved-dependencies = {} ; dependencies = []

    #

    resolve-dependency-reference = (parent-reference) !->

      { dependency-name-metadata: parent-metadata } = parent-reference
      { qualified-dependency-name: parent-dependency-name } = parent-metadata

      parent-key = lower-case parent-dependency-name

      was-already-resolved = resolved-dependencies[ parent-key ] isnt void

      if resolved-dependencies[ parent-key ] is void
        resolved-dependencies[ parent-key ] := build-dependency parent-metadata

      { dependencies-references = {} } = resolved-dependencies[ parent-key ]

      each-object-member dependencies-references, (key, child-reference) ->

        { dependency-name-metadata: { qualified-dependency-name } } = child-reference

        if resolved-dependencies[ lower-case qualified-dependency-name ] is void

          resolve-dependency-reference child-reference

      unless was-already-resolved
        dependencies.push resolved-dependencies[ parent-key ]

    #

    resolve-dependencies-references = (references) ->

      each-object-member references, (key, value) -> resolve-dependency-reference value

      dependencies

    {
      resolve-dependencies-references
    }