import carpenter/table
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
  |> glemo.memo("test", fn(x) {
    panic as "memoization not working"
    x
  })
  |> should.equal(False)

  cleanup()
}

pub fn record_test() {
  glemo.init(["test"])

  Test("test")
  |> glemo.memo("test", fn(x) { x.name })
  |> should.equal("test")

  Test("test")
  |> glemo.memo("test", fn(x) {
    panic as "memoization not working"
    x.name
  })
  |> should.equal("test")

  cleanup()
}
