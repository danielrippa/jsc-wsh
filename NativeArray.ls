
  NativeArray = do ->

    { must-be } = NativeType

    each-array-item = (array, proc) ->

      array `must-be` 'Array' ; proc `must-be` 'Function'

      for item, index in array => proc item, index, array

      array

    #

    map-array-items = (array, fn) ->

      array `must-be` 'Array' ; fn `must-be` 'Function'
      [ (fn item, index, array) for item, index in array ]

    #

    first-array-item = (array) -> array `must-be` 'Array' ; if array.length is 0 then null else array.0
    last-array-item  = (array) -> array `must-be` 'Array' ; if array.length is 0 then null else array[* - 1]

    #

    drop-first = (items, n = 1) -> (items `must-be` 'Array').slice (n `must-be` 'Number')
    drop-last  = (items, n = 1) -> (items `must-be` 'Array').slice 0, items.length - n

    #

    fold-array = (array, accumulator, fn) ->

      array `must-be` 'Array' ; fn `must-be` 'Function'

      for value, index in array => accumulator = fn accumulator, value, index, array

      accumulator

    #

    filter-array-items = (array, predicate) ->

      array `must-be` 'Array' ; predicate `must-be` 'Function'

      [ (item) for item, index in array when predicate item, index, array ]

    {
      each-array-item,
      map-array-items,
      first-array-item, last-array-item,
      drop-first, drop-last,
      fold-array,
      filter-array-items
    }