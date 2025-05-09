
  Pug = do ->

    { backward-slash } = NativeString

    pug-livescript-prefix = ":livescript(bare='true' header='#{ backward-slash }n')"

    {
      pug-livescript-prefix
    }