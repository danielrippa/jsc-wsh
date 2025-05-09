
  ComObject = do ->

    { must-be } = NativeType

    create-com-object = (automation-id) -> new ActiveXObject (automation-id `must-be` 'String')

    {
      create-com-object
    }