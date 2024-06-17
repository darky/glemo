import carpenter/table
import gleam/dict
import gleam/list
import gleeunit
import gleeunit/should
import glemo

type Test {
  Test(name: String)
}

pub fn main() {
  gleeunit.main()
}

@external(javascript, "./glemo_ffi.mjs", "cleanUp")
fn cleanup() -> Nil {
  let assert Ok(cache) = table.ref("test")
  table.drop(cache)
}

pub fn memoize_test() {
  glemo.init(["test"])

  1
  |> glemo.memo("test", fn(x) { x + 1 })
  |> should.equal(2)

  1
  |> glemo.memo("test", fn(x) { x + 999 })
  |> should.equal(2)

  5
  |> glemo.memo("test", fn(x) { x + 5 })
  |> should.equal(10)

  cleanup()
}

pub fn invalidation_test() {
  glemo.init(["test"])

  1
  |> glemo.memo("test", fn(x) { x + 1 })
  |> should.equal(2)

  glemo.invalidate_all("test")

  1
  |> glemo.memo("test", fn(x) { x + 9 })
  |> should.equal(10)

  2
  |> glemo.memo("test", fn(x) { x + 8 })
  |> should.equal(10)

  glemo.invalidate_specific(1, "test")

  1
  |> glemo.memo("test", fn(x) { x + 999 })
  |> should.equal(1000)

  2
  |> glemo.memo("test", fn(x) { x + 998 })
  |> should.equal(10)

  cleanup()
}

pub fn falsy_cached_test() {
  glemo.init(["test"])

  False
  |> glemo.memo("test", fn(x) { x })
  |> should.equal(False)

  False
  |> glemo.memo("test", fn(_) { panic as "memoization not working" })
  |> should.equal(False)

  cleanup()
}

pub fn record_test() {
  glemo.init(["test"])

  Test("test")
  |> glemo.memo("test", fn(x) { x.name })
  |> should.equal("test")

  Test("test")
  |> glemo.memo("test", fn(_) { panic as "memoization not working" })
  |> should.equal("test")

  cleanup()
}

pub fn list_test() {
  glemo.init(["test"])

  [1, 2, 3]
  |> glemo.memo("test", fn(x) { list.length(x) })
  |> should.equal(3)

  [1, 2, 3]
  |> glemo.memo("test", fn(_) { panic as "memoization not working" })
  |> should.equal(3)

  cleanup()
}

pub fn dict_test() {
  glemo.init(["test"])

  dict.from_list([#("test", 1)])
  |> glemo.memo("test", fn(x) { dict.size(x) })
  |> should.equal(1)

  dict.from_list([#("test", 1)])
  |> glemo.memo("test", fn(_) { panic as "memoization not working" })
  |> should.equal(1)

  cleanup()
}

pub fn tuple_test() {
  glemo.init(["test"])

  #(1, 2, 3)
  |> glemo.memo("test", fn(x) { x.2 })
  |> should.equal(3)

  #(1, 2, 3)
  |> glemo.memo("test", fn(_) { panic as "memoization not working" })
  |> should.equal(3)

  cleanup()
}
