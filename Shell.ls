
  Shell = do ->

    shell = -> new ActiveXObject 'WScript.Shell'

    get-current-folder = -> shell!CurrentDirectory

    {
      get-current-folder
    }