
  NativeObject = do ->

    { must-be } = NativeType

    object-member-names  = (object) -> object `must-be` 'Object' ; [ (member-name) for member-name of object ]
    object-member-values = (object) -> object `must-be` 'Object' ; [ (member-value) for member-name, member-value of object ]

    each-object-member = (object, proc) ->

      object `must-be` 'Object' ; proc `must-be` 'Function'

      for key, value of object => proc key, value, object

      object

    object-from-pairs = (pairs) -> { [ key, value ] for [ key, value ] in pairs }

    {
      object-member-names, object-member-values
      each-object-member,
      object-from-pairs
    }