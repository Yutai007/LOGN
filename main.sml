fun sort xs =
    let
        val indexed = ListPair.zip (xs, List.tabulate (length xs, fn i => i))
        fun rankOf (x, i) =
            List.length (
                List.filter (fn (y, j) => y < x orelse (y = x andalso j < i)) indexed
            )
        val rank = List.map (fn pair => (rankOf pair, #1 pair)) indexed
        fun rebuild [] acc = acc
        | rebuild ((r, v)::rest) acc =
            rebuild rest (List.update (acc, r, v))

        val empty = List.tabulate (length xs, fn _ => 0)
    in
        rebuild rank empty
    end