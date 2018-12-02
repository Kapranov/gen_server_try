# OTP GenServer, GenStage, Agent with Erlang Queue

* `GenServerTry.ShopGenserver` - GenServer example.
* `GenServerTry.ShopAgent` - Agent example.
* `GenServerTry.ShopQueue` - Queue example.

```
queue = :queue.new                  #=> {[], []}

data = :queue.in("item-1", queue)   #=> {["item-1"], []}
data = :queue.in("item-2", data)    #=> {["item-2"], ["item-1"]}
data = :queue.in("item-3", data)    #=> {["item-3", "item-2"], ["item-1"]}

data
#=> {["item-3", "item-2"], ["item-1"]}

# Inserts Item at the head of queue Q1. Returns the new queue Q2.
:queue.cons("item-4", data)
#=> {["item-3", "item-2"], ["item-4", "item-1"]}

# Returns the tail item of queue Q.
:queue.daeh(data)
#=> "item-3"

# Returns a queue Q2 that is the result of removing the front item from Q1.
:queue.drop(data)
#=> {["item-3"], ["item-2"]}

# Returns a queue Q2 that is the result of removing the rear item from Q1.
:queue.drop_r(data)
#=> {["item-2"], ["item-1"]}

# Returns a queue Q2 that is the result of calling Fun(Item) on all
# items in Q1, in order from front to rear.
:queue.filter()

# Returns a queue containing the items in L in the same order; the head
# item of the list becomes the front item of the queue.
foods = ~w|item-1 item-2 otem-3|s
foods |> :queue.from_list
#=> {["otem-3"], ["item-1", "item-2"]}

data |> :queue.to_list
#=> ["item-1", "item-2", "item-3"]

data |> :queue.to_list |> :queue.from_list
#=> {["item-3"], ["item-1", "item-2"]}

# Inserts Item at the rear of queue Q1. Returns the resulting queue Q2.
:queue.in("item-4", data)
#=> {["item-4", "item-3", "item-2"], ["item-1"]}

# Inserts Item at the front of queue Q1. Returns the resulting queue Q2.
:queue.in_r("item-4", data)
#=> {["item-3", "item-2"], ["item-4", "item-1"]}

# Tests if Q is empty and returns true if so, otherwise otherwise.
:queue.is_empty(data)
#=> false

new = :queue.new
:queue.is_empty(new)
#=> true

# Tests if Term is a queue and returns true if so, otherwise false.
:queue.is_queue(data)
#=> true

new = :queue.new
:queue.is_queue(new)
#=> false

# Returns a queue Q3 that is the result of joining Q1 and Q2 with Q1 in
# front of Q2.
#=>

# Returns Item from the head of queue Q.
:queue.head(data)
#=> "item-1"

# Returns a queue Q2 that is the result of removing the tail item from Q1.
:queue.init(data)
#=> {["item-2"], ["item-1"]}

# Returns a queue Q2 that is the result of removing the tail item from Q1.
:queue.lait(data)
#=> {["item-2"], ["item-1"]}

# Returns the tail item of queue Q.


```

### 28 November 2018 by Oleg G.Kapranov

[1]: http://erlang.org/doc/man/queue.html
