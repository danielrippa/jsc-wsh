
  ScriptComposer = do ->

    { map-array-items } = NativeArray
    { indent-string } = NativeString
    { comment-lines, indent-lines } = Livescript
    { absolute-path } = FileSystem
    { compose-dependencies-references } = DependenciesComposer

    compose-main-script-source = (script-filepath, dependencies-references, livescript-lines) ->

      * "Main Script #script-filepath"
        "(#{ absolute-path script-filepath })"

      |> comment-lines
      |> indent-lines 2, _

      |> (++ indent-lines 2, compose-dependencies-references dependencies-references)
      |> (++ livescript-lines)

    {
      compose-main-script-source
    }