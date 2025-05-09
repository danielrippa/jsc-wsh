
  NativeError = do ->

    throw-error = (message) -> throw new Error message

    {
      throw-error
    }