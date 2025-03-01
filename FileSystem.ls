
  FileSystem = do ->

    file-system = -> new ActiveXObject 'Scripting.FileSystemObject'

    fs = file-system!

      file-exists = -> ..FileExists it
      folder-exists = -> ..FolderExists it

      get-name = -> ..GetBaseName it
      get-absolute-path = -> ..GetAbsolutePathName it

    path-separator = '\\'

    {
      file-system,
      file-exists, folder-exists,
      get-name, get-absolute-path,
      path-separator
    }
