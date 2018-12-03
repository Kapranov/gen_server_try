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

**GenStage OTP**

### 28 November 2018 by Oleg G.Kapranov

[1]: http://erlang.org/doc/man/queue.html
[2]: https://youtu.be/M78r_PDlw2c
[3]: https://github.com/wfgilman/stage_test
[4]: https://github.com/cloud8421/osteria
[5]: https://github.com/ybur-yug/genstage_tutorial
[6]: https://elixirschool.com/en/lessons/advanced/gen-stage
[7]: https://gist.github.com/BruOp/fdf6513e2df4274f9266c9cb5ee8a7fb
[8]: https://medium.com/@andreichernykh/elixir-a-few-things-about-genstage-id-wish-to-knew-some-time-ago-b826ca7d48ba
[9]: https://sheharyar.me/blog/understanding-genstage-elixir/
[10]: https://blog.emerleite.com/using-elixir-genstage-to-track-video-watch-progress-9b114786c604
[11]: http://www.elixirfbp.org/2016/07/genstage-example.html
[12]: http://www.elixirfbp.org/2016/08/genstage-example-no-3-dispatching.html
[13]: https://github.com/pcmarks/genstage_example
[14]: https://github.com/pcmarks/genstage_example_2
[15]: https://github.com/pcmarks/gen_stage_example_3
