
  FileSystem = do ->

    { create-com-object } = ComObject
    { must-be } = NativeType
    { backward-slash } = NativeString

    file-system = -> create-com-object 'Scripting.FileSystemObject'

    absolute-path = -> file-system!GetAbsolutePathName (it `must-be` 'String')

    file-name = -> file-system!GetBaseName (it `must-be` 'String')

    filepath-separator = backward-slash

    build-path = -> (it `must-be` 'Array') * "#filepath-separator"

    does-folder-exist = -> file-system!FolderExists (it `must-be` 'String')
    does-file-exist   = -> file-system!FileExists   (it `must-be` 'String')

    get-current-folderpath = -> create-com-object 'WScript.Shell' .CurrentDirectory

    parent-folderpath = -> file-system!GetParentFolderName (it `must-be` 'String')

    {
      file-system,
      absolute-path,
      file-name,
      filepath-separator,
      build-path,
      does-folder-exist, does-file-exist,
      get-current-folderpath,
      parent-folderpath
    }