import carpenter/table
import gleam/list

pub fn init(caches: List(String)) {
  list.each(caches, fn(cache_name) {
    table.build(cache_name)
    |> table.privacy(table.Public)
    |> table.write_concurrency(table.AutoWriteConcurrency)
    |> table.read_concurrency(True)
    |> table.decentralized_counters(True)
    |> table.compression(False)
    |> table.set
  })
}

pub fn memo(arg: x, cache_name: String, fun: fn(x) -> r) -> r {
  let assert Ok(cache) = table.ref(cache_name)
  case table.lookup(cache, arg) {
    [x, ..] -> x.1
    [] -> {
      let resp = fun(arg)
      table.insert(cache, [#(arg, resp)])
      resp
    }
  }
}

pub fn invalidate_all(cache_name: String) {
  let assert Ok(cache) = table.ref(cache_name)
  table.delete_all(cache)
}

pub fn invalidate_specific(arg: x, cache_name: String) {
  let assert Ok(cache) = table.ref(cache_name)
  table.delete(cache, arg)
}
