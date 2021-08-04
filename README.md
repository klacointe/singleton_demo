# SingletonDemo

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `singleton_demo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:singleton_demo, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/singleton_demo](https://hexdocs.pm/singleton_demo).


## Reproduce singleton bug with more than 3 singletons

If you only start 3 instances of `SingletonDemo.PeriodicLogger` it works.

With 4 instances we can see that singleton application was shutdown when the second node
connects.

If you try with this
[fork](https://github.com/klacointe/singleton/tree/FIX-more-than-three-singletons),
and add this configuration, it works with more than 3 singletons :

```elixir
config :singleton,
  dynamic_supervisor: [max_restarts: 100]
```

### First node output

```sh
$ iex --sname foo -S mix
Erlang/OTP 23 [erts-11.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Compiling 3 files (.ex)
Generated singleton_demo app

13:51:04.824 [info]  [PeriodicLogger [:one]] initializing…

13:51:04.826 [info]  [PeriodicLogger [:two]] initializing…

13:51:04.826 [info]  [PeriodicLogger [:three]] initializing…

13:51:04.827 [info]  [PeriodicLogger [:four]] initializing…
Interactive Elixir (1.12.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(foo@marvin)1>
13:51:06.827 [info]  [PeriodicLogger [:one]] working…

13:51:06.827 [info]  [PeriodicLogger [:two]] working…

13:51:06.828 [info]  [PeriodicLogger [:three]] working…

13:51:06.828 [info]  [PeriodicLogger [:four]] working…

13:51:08.827 [info]  [PeriodicLogger [:one]] working…

13:51:08.828 [info]  [PeriodicLogger [:two]] working…

13:51:08.828 [info]  [PeriodicLogger [:four]] working…

13:51:08.829 [info]  [PeriodicLogger [:three]] working…

13:51:10.828 [info]  [PeriodicLogger [:one]] working…

13:51:10.829 [info]  [PeriodicLogger [:two]] working…

13:51:10.829 [info]  [PeriodicLogger [:three]] working…

13:51:10.830 [info]  [PeriodicLogger [:four]] working…

13:51:12.402 [info]  Application singleton exited: shutdown
```

### Second node output

```sh
$ iex --sname bar -S mix
Erlang/OTP 23 [erts-11.2.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]


13:51:06.247 [info]  [PeriodicLogger [:one]] initializing…

13:51:06.248 [info]  [PeriodicLogger [:two]] initializing…

13:51:06.248 [info]  [PeriodicLogger [:three]] initializing…

13:51:06.248 [info]  [PeriodicLogger [:four]] initializing…
Interactive Elixir (1.12.1) - press Ctrl+C to exit (type h() ENTER for help)
iex(bar@marvin)1>
13:51:08.249 [info]  [PeriodicLogger [:three]] working…

13:51:08.249 [info]  [PeriodicLogger [:two]] working…

13:51:08.249 [info]  [PeriodicLogger [:four]] working…

13:51:08.249 [info]  [PeriodicLogger [:one]] working…

13:51:10.250 [info]  [PeriodicLogger [:two]] working…

13:51:10.250 [info]  [PeriodicLogger [:three]] working…

13:51:10.250 [info]  [PeriodicLogger [:one]] working…

13:51:10.250 [info]  [PeriodicLogger [:four]] working…
iex(bar@marvin)1> Node.connect(:foo@marvin)
true
iex(bar@marvin)2>
13:51:12.251 [info]  [PeriodicLogger [:three]] working…

13:51:12.251 [info]  [PeriodicLogger [:two]] working…

13:51:12.251 [info]  [PeriodicLogger [:four]] working…

13:51:12.251 [info]  [PeriodicLogger [:one]] working…

13:51:12.320 [info]  global: Name conflict terminating {{:periodic_logger, :four}, #PID<19752.248.0>}


13:51:12.329 [info]  global: Name conflict terminating {{:periodic_logger, :one}, #PID<19752.242.0>}


13:51:12.329 [info]  global: Name conflict terminating {{:periodic_logger, :three}, #PID<19752.246.0>}


13:51:12.329 [info]  global: Name conflict terminating {{:periodic_logger, :two}, #PID<19752.244.0>}


13:51:14.252 [info]  [PeriodicLogger [:two]] working…

13:51:14.252 [info]  [PeriodicLogger [:four]] working…

13:51:14.252 [info]  [PeriodicLogger [:one]] working…

13:51:14.252 [info]  [PeriodicLogger [:three]] working…
```

