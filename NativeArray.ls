
  NativeArray = do ->

    first-item = (.0)
    last-item = -> it[* - 1]

    map-items = (items, fn) -> [ (fn item, index, items) for item,index in items ]

    drop-first = (items, n = 1) -> items.slice n
    drop-last  = (items, n = 1) -> items.slice 0, items.length - n

    {
      first-item, last-item,
      drop-first, drop-last,
      map-items
    }