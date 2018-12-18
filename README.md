# OTP GenServer, GenStage, Agent with Erlang Queue

* GenServer example - `GenServerTry.ShopGenserver`
* Agent example - `GenServerTry.ShopAgent`
* Queue example - `GenServerTry.ShopQueue`
* GenStage example - `GenServerTry.ShopGenstage`

**queue - Erlang bstract data type for FIFO queues**

`queue` - This module provides (double-ended) FIFO queues in an efficient manner.

```
db1 = :queue.new #=> {[], []}
db2 = :queue.new #=> {[], []}

db1 = :queue.in("dataItem1-1", db1)
db1 = :queue.in("dataItem1-2", db1)
db1 = :queue.in("dataItem1-3", db1)

db2 = :queue.in("dataItem2-1", db1)
db2 = :queue.in("dataItem2-2", db1)
db2 = :queue.in("dataItem2-3", db1)

db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}

db2
#=> {["dataItem2-3", "dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}

# Inserts `Item` at the head of queue `Q1`. Returns the new queue `Q2`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.cons("dataItem-4", db1)
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem-4", "dataItem1-1"]}

# Returns the tail item of queue `Q`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.daeh(db1)
#=> "dataItem1-3"

# Returns a queue `Q2` that is the result of removing the front item from `Q1`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.drop(db1)
#=> {["dataItem1-3"], ["dataItem1-2"]}

# Returns a queue `Q2` that is the result of removing the rear item from `Q1`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.drop_r(db1)
#=> {["dataItem1-2"], ["dataItem1-1"]}

# Returns a queue `Q2` that is the result of calling `Fun(Item)` on all
# items in `Q1`, in order from front to rear.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.filter(fn x -> x == "dataItem1-3" end, db1)
#=> {[], ["dataItem1-3"]}
:queue.filter(fn x -> x == "dataItem1-2" end, db1)
#=> {[], ["dataItem1-2"]}
:queue.filter(fn x -> x == "dataItem1-1" end, db1)
#=> {["dataItem1-1"], []}

# Returns a queue containing the items in `L` in the same order; the head
# item of the list becomes the front item of the queue.
db
#=> ["dataItem1-3", "dataItem1-2", "dataItem1-1"]
:queue.from_list(db)
#=> {["dataItem1-1"], ["dataItem1-3", "dataItem1-2"]}

# Returns `Item` at the front of queue `Q`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.get(db1)
#=> "dataItem1-1"

# Returns `Item` at the rear of queue `Q`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.get_r(db1)
#=> "dataItem1-3"

# Returns `Item` from the head of queue `Q`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.head(db1)
#=> "dataItem1-1"

# Inserts `Item` at the rear of queue `Q1`. Returns the resulting queue `Q2`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.in("item-4", db1)
#=> {["dataItem-4", "dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}

# Inserts `Item` at the front of queue `Q1`. Returns the resulting queue `Q2`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.in_r("dataItem-4", db1)
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem-4", "dataItem1-1"]}

# Returns a queue `Q2` that is the result of removing the tail item from `Q1`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.init(db1)
#=> {["dataItem1-2"], ["dataItem1-1"]}

# Tests if `Q` is empty and returns `true` if so, otherwise otherwise.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.is_empty(db1)
#=> false
db3 = :queue.new
:queue.is_empty(db3)
#=> true

# Tests if `Term` is a queue and returns `true` if so, otherwise `false`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.is_queue(db1)
#=> true
db3 = :queue.new
:queue.is_queue(db3)
#=> false

# Returns a queue `Q3` that is the result of joining `Q1` and `Q2` with `Q1` in front of `Q2`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
db2
#=> {["dataItem2-3", "dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.join(db1, db2)
#=> {
      ["dataItem2-3", "dataItem1-3", "dataItem1-2"],
      ["dataItem1-1", "dataItem1-2", "dataItem1-3", "dataItem1-1"]
    }

# Returns a queue `Q2` that is the result of removing the tail item from `Q1`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.lait(db1)
#=> {["dataItem1-2"], ["dataItem1-1"]}

# Returns the tail item of queue `Q`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.last(db1)
#=> "dataItem1-3"

# Calculates and returns the length of queue `Q`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.len(db1)
#=> 3

# Returns a queue `Q2` that is the result of removing the tail item from `Q1`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.liat(db1)
#=> {["dataItem1-2"], ["dataItem1-1"]}

# Returns `true` if `Item` matches some element in `Q`, otherwise `false`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.member("dataItem1-2", db1)
#=> true
:queue.member("dataItem1-4", db1)
#=> false

# Returns an empty queue.
db1 = :queue.new

# Removes the item at the front of queue `Q1`. Returns tuple `{{value, Item}, Q2}`,
# where `Item` is the item removed and `Q2` is the resulting queue. If `Q1` is empty,
# tuple `{empty, Q1}` is returned.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.out(db1)
#=> {{:value, "dataItem1-1"}, {["dataItem1-3"], ["dataItem1-2"]}}

# Removes the item at the rear of queue `Q1`. Returns tuple `{{value, Item}, Q2}`,
# where `Item` is the item removed and `Q2` is the new queue. If `Q1` is empty,
# tuple `{empty, Q1}` is returned.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.out_r(db1)
#=> {{:value, "dataItem1-3"}, {["dataItem1-2"], ["dataItem1-1"]}}

# Returns tuple `{value, Item}`, where `Item` is the front item of `Q`, or
# `empty` if `Q` is empty.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.peek(db1)
#=> {:value, "dataItem1-1"}

# Returns tuple `{value, Item}`, where `Item` is the rear item of `Q`, or
# `empty` if `Q` is empty.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.peek_r(db1)
#=> {:value, "dataItem1-3"}

# Returns a queue `Q2` containing the items of `Q1` in the reverse order.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.reverse(db1)
#=> {["dataItem1-1"], ["dataItem1-3", "dataItem1-2"]}

# Inserts `Item` as the tail item of queue `Q1`. Returns the new queue `Q2`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
db2
#=> {["dataItem2-3", "dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.snoc(db1, db2)
#=> {
      [
        {
          ["dataItem2-3", "dataItem1-3", "dataItem1-2"],
          ["dataItem1-1"]
        },
        "dataItem1-3",
        "dataItem1-2"
      ],
      [
        "dataItem1-1"
      ]
    }

:queue.snoc(db2, db1)
#=> {
      [
        {
          ["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]
        },
        "dataItem2-3",
        "dataItem1-3",
        "dataItem1-2"
      ],
      [
        "dataItem1-1"
      ]
    }

# Splits `Q1` in two. The `N` front items are put in `Q2` and the rest in `Q3`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.split(0, db1)
#=> {{[], []}, {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}}
:queue.split(1, db1)
#=> {{["dataItem1-1"], []}, {["dataItem1-3"], ["dataItem1-2"]}}
:queue.split(2, db1)
#=> {{["dataItem1-2"], ["dataItem1-1"]}, {["dataItem1-3"], []}}
:queue.split(3, db1)
#=> {{["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}, {[], []}}

# Returns a queue `Q2` that is the result of removing the head item from `Q1`.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.tail(db1)
#=> {["dataItem1-3"], ["dataItem1-2"]}

# Returns a list of the items in the queue in the same order; the front
# item of the queue becomes the head of the list.
db1
#=> {["dataItem1-3", "dataItem1-2"], ["dataItem1-1"]}
:queue.to_list(db1)
#=> ["dataItem1-1", "dataItem1-2", "dataItem1-3"]
```

```
def handle_call(event, _from, {queue}),
  do {:reply, :ok, [], {:queue.in(event, queue)}}


def handle_call(event, _from, {queue, 0}),
  do {:reply, :ok, [], {:queue.in(event, queue), 0}}

 def handle_call(event, _from, {queue, demand}),
  do {:reply, :ok, [event], {queue, demand-1}}

def handle_demand(_new_demand, {queue}) do
  Logger.info("producer: new demand")
  case :queue.out(queue) do
    {{:value, event}, queue} ->
      {:noreply, [event], {queue}}
    {:empty, queue} ->
      Logger.info("producer: empty queue")
      {:noreply, [], {queue}}
  end
end
```

**GenStage OTP**

```
producer -> producer-consumer -> producer-consumer -> producer-consumer -> consumer
```

What is GenStage? From the official documentation, it is a
"specification and computational flow for Elixir", but what does that
mean.

What it means is that GenStage provides a way for us to define a
pipeline of work to be carried out by independent steps (or stages) in
a separate processes; if you've worked with pipelines before then some
of these concepts should be familiar.

To better understand how this works, let's visualize a simple
producer-consumer flow:

```
[A] -> [B] -> [C]
```

In this example we have three stages: `A` a producer, `B` a producer-
consumer, and `C` a consumer.
`A` produces a value which is consumed by `B`, `B` performs some work
and returns a new value which is received by our consumer `C`; the
role of our stage is important as we'll see in the next section.

To better illustrate these concepts we'll be constructing a pipeline
with GenStage but first let's explore the roles that GenStage relies
upon a bit further.

As we've read, the role we give our stage is important. The GenStage
specification recognizes three roles:

* `:producer` - A source. Producers wait for demand from consumers and
  respond with the requested events.
* `:producer_consumer` - Both a source and a sink. Producer-consumers
  can respond to demand from other consumers as well as request events
  from producers.
* `:consumer` - A sink. A consumer requests and receives data from
  producers.

Notice that our producers wait for demand?  With GenStage our consumers
send demand upstream and process the data from our producer. This
facilitates a mechanism known as back-pressure. Back-pressure puts the
onus on the producer to not over-pressure when consumers are busy.

Now that we've covered the roles within GenStage let's start on our
example in code `lib/gen_server_try/shop_genstage.ex`

```elixir
defmodule A do
  use GenStage

  def start_link(number) do
    GenStage.start_link(A, number)
  end

  def init(counter) do
    {:producer, counter}
  end

  def handle_demand(demand, counter) when demand > 0 do
    # If the counter is 3 and we ask for 2 items, we will
    # emit the items 3 and 4, and set the state to 5.
    events = Enum.to_list(counter..counter+demand-1)
    {:noreply, events, counter + demand}
  end
end

defmodule B do
  use GenStage

  def start_link(number) do
    GenStage.start_link(B, number)
  end

  def init(number) do
    {:producer_consumer, number, subscribe_to: [{A, max_demand: 10}]}
  end

  def handle_events(events, _from, number) do
    events = Enum.map(events, & &1 * number)
    {:noreply, events, number}
  end
end

defmodule C do
  use GenStage

  def start_link() do
    GenStage.start_link(C, :ok)
  end

  def init(:ok) do
    {:consumer, :the_state_does_not_matter, subscribe_to: [B]}
  end

  def handle_events(events, _from, state) do
    # Wait for a second.
    Process.sleep(1000)

    # Inspect the events.
    IO.inspect(events)

    # We are a consumer, so we would never emit items.
    {:noreply, [], state}
  end
end

# If I run them manually it works

iex> GenStage.start_link(A, 0, name: A)
#=> {:ok, #PID<0.195.0>}
iex> GenStage.start_link(B, 2, name: B)
#=> {:ok, #PID<0.197.0>}
iex> GenStage.start_link(C, :ok)
#=> {:ok, #PID<0.199.0>}
[0, 2, 4, 6, 8]
[10, 12, 14, 16, 18]
[20, 22, 24, 26, 28]
[30, 32, 34, 36, 38]

# In a supervision tree, this is often done by starting multiple
# workers:
defmodule TestDep.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(A, [0]),
      worker(B, [2]),
      worker(C, []),
    ]

    opts = [strategy: :rest_for_one]
    Supervisor.start_link(children, opts)
  end
end

# mix.exs
def application do
  [
    extra_applications: [:logger],
    mod: {TestDep.Application, []}
  ]
end

# start_link methods must be updated to receive also the process’s name
# old
def start_link(number) do
  GenStage.start_link(A, number)
end

# to new
def start_link(number) do
  GenStage.start_link(A, number, name: A)
end

The `doc` doesn't explicitly encourages that although it shows you how to
call the updated `start_link` function with:
`GenStage.start_link(A, 0, name: A)`
```

```elixir
defmodule Json do
  def flatten(%{} = json) do
    json
    |> Map.to_list()
    |> to_flat_map(%{})
  end

  def flatten(%{} = json) when json == %{}, do: %{}

  defp to_flat_map([{_k, %{} = v} | t], acc), do: to_flat_map(Map.to_list(v), to_flat_map(t, acc))
  defp to_flat_map([{k, v} | t], acc), do: to_flat_map(t, Map.put_new(acc, k, v))
  defp to_flat_map([], acc), do: acc
end

%{id: "1", foo: %{bar: %{qux: "hello world"}, baz: 123}}
|> Json.flatten()
|> IO.inspect()
# %{baz: 123, id: "1", qux: "hello world"}

defmodule Foo do
  def flatten_map(map) when is_map(map) do
    map
    |> Map.to_list
    |> do_flatten([])
    |> Map.new
  end

  defp do_flatten([], acc), do: acc

  defp do_flatten([{_k, v} | rest], acc) when is_map(v) do
    v = Map.to_list(v)
    flattened_subtree = do_flatten(v, acc)
    do_flatten(flattened_subtree ++ rest, acc)
  end

  defp do_flatten([kv | rest], acc) do
    do_flatten(rest, [kv | acc])
  end
end

defmodule Foo do
  def flatten_map(map) when is_map(map) do
    map
    |> Map.to_list
    |> do_flatten([])
    |> Map.new
  end

  defp do_flatten([], acc), do: acc

  defp do_flatten([{_k, v} | rest], acc) when is_map(v) do
    v = Map.to_list(v)
    flattened_subtree = do_flatten(v, acc)
    do_flatten(flattened_subtree ++ rest, acc)
  end

  defp do_flatten([kv | rest], acc) do
    do_flatten(rest, [kv | acc])
    end
  end
end

def flatten_map(list) when is_list(list) do
  list
  |> do_flatten([])
  |> Map.new
end

defp do_flatten([{_k, v} | rest], acc) when is_map(v) do
  v = Map.to_list(v)
  flattened_subtree = do_flatten(v, acc)
  do_flatten(flattened_subtree ++ rest, acc)
end
```

```elixir
def flatten(list), do: flatten(list, []) |> Enum.reverse
def flatten([h | t], acc) when h == [], do: flatten(t, acc)
def flatten([h | t], acc) when is_list(h), do: flatten(t, flatten(h,
acc))
def flatten([h | t], acc), do: flatten(t, [h | acc])
def flatten([], acc), do: acc

def flatten(list), do: flatten(list, [])
def flatten([h | t], acc) when h == [], do: flatten(t, acc)
def flatten([h | t], acc) when is_list(h), do: flatten(t, flatten(h,
acc))
def flatten([h | t], acc), do: flatten(t, acc ++ [h])
def flatten([], acc), do: acc

defmodule FlattenReverse do
  def flatten(list), do: flatten(list, []) |> Enum.reverse
  def flatten([h | t], acc) when h == [], do: flatten(t, acc)
  def flatten([h | t], acc) when is_list(h), do: flatten(t, flatten(h, acc))
  def flatten([h | t], acc), do: flatten(t, [h | acc])
  def flatten([], acc), do: acc
end
defmodule FlattenAppend do
  def flatten(list), do: flatten(list, [])
  def flatten([h | t], acc) when h == [], do: flatten(t, acc)
  def flatten([h | t], acc) when is_list(h), do: flatten(t, flatten(h, acc))
  def flatten([h | t], acc), do: flatten(t, acc ++ [h])
  def flatten([], acc), do: acc
end
list = List.duplicate(0, 200) |> List.duplicate(200)
{time, _} = :timer.tc fn -> FlattenReverse.flatten(list) end
IO.puts "Flatten reverse took #{time}"
{time, _} = :timer.tc fn -> FlattenAppend.flatten(list) end
IO.puts "Flatten append took #{time}"

def flatten(list), do: flatten(list, [])
def flatten([h | t], acc), do: flatten(t, h ++ acc)
def flatten([], acc), do: acc

List.foldl(list, [], &(&1 ++ &2))

defmodule List do
  def flatten(list, depth \\ -2), do: flatten(list, depth + 1, []) |> Enum.reverse
  def flatten(list, 0, acc), do: [list | acc]
  def flatten([h | t], depth, acc) when h == [], do: flatten(t, depth, acc)
  def flatten([h | t], depth, acc) when is_list(h), do: flatten(t, depth, flatten(h, depth - 1, acc))
  def flatten([h | t], depth, acc), do: flatten(t, depth, [h | acc])
  def flatten([], _, acc), do: acc
end
list = [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]
List.flatten(list, 0)   # [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8]
List.flatten(list, 1)   # [1, 2, [3, 4], 5, [[]], [[6]], 7, 8]
List.flatten(list, 2)   # [1, 2, 3, 4, 5, [6], 7, 8]
List.flatten(list, 3)   # [1, 2, 3, 4, 5, 6, 7, 8]
List.flatten(list)      # [1, 2, 3, 4, 5, 6, 7, 8]
List.flatten(list, -1)   # [[[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]]

```

```elixir
defmodule MySigils do
  @moduledoc ~S"""
  Genrating the custom sigils.
  """
  @doc ~S"""
  This converts the given strings in to the path by joining each string
with /.
  If you provide an option `u` it will treat the first string as domain
and prepend
  that string with https://www. and add the rest of strings as path.
  """

  ##  Examples

        iex> ~p/user 1234 delete/
        "user/1234/delete"

        iex> ~p/medium.com blackode/u
        "https://www.medium.com/blackode"
  """

  def sigil_p binary, [] do
    binary
    |> String.split
    |> Enum.join("/")
  end

  def sigil_p binary, [?u] do
    string_list = String.split binary
    "https://www." <> Enum.join(string_list, "/")
  end
end

h MySigils.sigil_p
import MySigils
~p/user 123 delete/
 ~p/medium.com blackode/
 ~p/medium.com blackode/u
```

# Tasks

```elixir
defmodule Fib do
  def of(0), do: 0
  def of(1), do: 1
  def of(n), do: Fib.of(n-1) + Fib.of(n-2)
end

worker = Task.async(fn -> Fib.of(20) end)
result = Task.await(worker)
result
```

### 28 November 2018 by Oleg G.Kapranov

[1]:  http://erlang.org/doc/man/queue.html
[2]:  https://hexdocs.pm/gen_stage/GenStage.html
[3]:  https://elixirschool.com/en/lessons/advanced/gen-stage
[4]:  https://www.youtube.com/watch?v=M78r_PDlw2c
[5]:  https://github.com/elixir-lang/gen_stage
[6]:  https://github.com/wfgilman/stage_test
[7]:  https://github.com/billperegoy/gen_stage_example
[8]:  https://github.com/pcmarks/genstage_example
[9]:  https://github.com/pcmarks/genstage_example_2
[10]: https://github.com/pcmarks/gen_stage_example_3
[11]: https://github.com/cloud8421/osteria
[12]: https://github.com/ybur-yug/genstage_tutorial
[13]: https://github.com/brianstorti/elixir-registry-example-chat-app
[14]: https://github.com/floriank/postgres_sync_file_fdw
[15]: https://github.com/kloeckner-i/genstage_importer
[16]: https://github.com/elixir-lang/gen_stage/blob/master/examples/producer_consumer.exs
[17]: https://becoming-functional.com/getting-started-with-elixirs-genserver-ed05a9202bef
[18]: https://m.alphasights.com/process-registry-in-elixir-a-practical-example-4500ee7c0dcc
[19]: https://elixir-lang.org/blog/2016/07/14/announcing-genstage/
[20]: https://www.slideshare.net/Elixir-Meetup/genstage-and-flow-jose-valim
[21]: https://work.stevegrossi.com/talks/all-the-worlds-a-gen-stage
[22]: https://sheharyar.me/blog/understanding-genstage-elixir/
[23]: http://samuelmullen.com/articles/more-than-1-1-with-elixirs-genstage/
[24]: https://engineering.spreedly.com/blog/how-do-i-genstage.html
[25]: http://www.elixirfbp.org/2016/07/genstage-example.html
[26]: http://www.elixirfbp.org/2016/08/genstage-example-no-2.html
[27]: http://www.elixirfbp.org/2016/08/genstage-example-no-3-dispatching.html
[28]: https://medium.com/@scripbox_tech/background-processing-in-elixir-with-genstage-efb6cb8ca94a
[29]: https://blog.emerleite.com/using-elixir-genstage-to-track-video-watch-progress-9b114786c604
[30]: https://floriank.github.io/post/the-steel-industry-file_fdw-and-postgres/
[31]: https://medium.com/@andreichernykh/elixir-a-few-things-about-genstage-id-wish-to-knew-some-time-ago-b826ca7d48ba
[32]: https://medium.com/mint-digital/stateful-websockets-with-elixirs-genstage-a29eab420c0d
[33]: https://blog.kloeckner.de/building-a-data-import-pipeline-using-genstage-and-flow/
