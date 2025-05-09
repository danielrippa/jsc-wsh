
  NativeType = do ->

    { throw-error } = NativeError

    value-type-tag = (value) ->

      type-tag = {} |> (.to-string) |> (.call value) |> (.slice 8, -1)

      switch type-tag

        | 'Object' =>

          switch value

            | void => 'Undefined'
            | null => 'Null'

            else type-tag

        else type-tag

    #

    array-as-string = -> "[ #{ if it.length is 0 then '' else it * ', ' } ]"

    #

    value-as-string = (value) ->

      switch value-type-tag value

        | 'String' => "'#value'"
        | 'Array'  => [ (value-as-string item) for item in value ] |> array-as-string

    #

    must-be = (value, type-tag) ->

      actual-type-tag = value-type-tag value

      throw-error "Value (#actual-type-tag) #{ value-as-string value } must be #type-tag" \
        unless actual-type-tag is type-tag

      value

    {
      value-type-tag,
      value-as-string,
      must-be
    }