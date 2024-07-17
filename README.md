# glemo

[![Package Version](https://img.shields.io/hexpm/v/glemo)](https://hex.pm/packages/glemo)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glemo/)
![Erlang-compatible](https://img.shields.io/badge/target-erlang-a2003e)
![JavaScript-compatible](https://img.shields.io/badge/target-javascript-f1e05a)

Simple function memoization over Erlang ETS / JavaScript Map for Gleam

```sh
gleam add glemo
```
```gleam
import glemo

pub fn main() {
  // init caches on application startup
  glemo.init(["my_cache"])

  // try get from cache
  // on first attempt item not exists in cache
  // fallback function will be called
  // result of fallback function will be placed to cache, function argument is used as key
  1
  |> glemo.memo("my_cache", fn(x) { x + 1 }) // 2

  // now value returned from cache, fallback function ignored
  1
  |> glemo.memo("my_cache", fn(x) { x + 1 }) // 2

  // invalidate cache item by specific key
  glemo.invalidate_specific(1, "my_cache")

  // invalidate all cache
  glemo.invalidate_all("my_cache")
}
```

Further documentation can be found at <https://hexdocs.pm/glemo>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
