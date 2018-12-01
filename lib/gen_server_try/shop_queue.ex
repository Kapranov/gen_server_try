defmodule GenServerTry.ShopQueue do
  @moduledoc """
  Implementation Shopping Cart by OTP GenServer with Erlang module Queue

  Queue is an abstract data type for FIFO queues.
  This module provides (double-ended) FIFO queues in an efficient manner.
  """

  use GenServer

  @name __MODULE__

  @doc """
  Starts a `GenServer` process linked to the current process.
  """
  def start_link, do: GenServer.start_link(@name, :queue.new())

  @doc """
  Show all items from cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopQueue.start_link
      iex> GenServerTry.ShopQueue.show(pid)
      []
  """
  def show(pid), do: GenServer.call(pid, :show)

  @doc """
  Count all items in cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopQueue.start_link
      iex> GenServerTry.ShopQueue.count(pid)
      0
  """
  def count(pid), do: GenServer.call(pid, :count)

  @doc """
  Delete first item from list in cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopQueue.start_link
      iex> GenServerTry.ShopQueue.fetch(pid)
      :empty
  """
  def fetch(pid), do: GenServer.call(pid, :fetch)

  @doc """
  Reset all items and create empty list

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopQueue.start_link
      iex> GenServerTry.ShopQueue.reset(pid)
      {[], []}
  """
  def reset(pid), do: GenServer.call(pid, :reset)

  @doc """
  Add item to cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopQueue.start_link
      iex> GenServerTry.ShopQueue.add(pid, "item-1")
      :ok
  """
  def add(pid, item), do: GenServer.cast(pid, {:add, item})

  @doc """
  Update item to new item

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopQueue.start_link
      iex> GenServerTry.ShopQueue.add(pid, "item-1")
      :ok
      iex> GenServerTry.ShopQueue.update(pid, "item-1", "item-0")
      :ok
  """
  def update(pid, old_item, new_item) do
    GenServer.cast(pid, {:update, old_item, new_item})
  end

  @doc """
  Delete item from cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopQueue.start_link
      iex> GenServerTry.ShopQueue.del(pid, "item-1")
      :ok
  """
  def del(pid, item), do: GenServer.cast(pid, {:del, item})

  @doc """
  Stop Shopping Cart GenServer

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopQueue.start_link
      iex> GenServerTry.ShopQueue.stop(pid)
      :ok
  """
  def stop(pid) do
    terminate(pid)
    GenServer.stop(pid, :normal, :infinity)
  end

  @impl true
  @doc false
  def init(args), do: {:ok, args}

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:show`
  """
  def handle_call(:show, _from, queue) do
    {:reply, :queue.to_list(queue), queue}
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:count`
  """
  def handle_call(:count, _from, queue) do
    {:reply, :queue.len(queue), queue}
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:fetch`
  """
  def handle_call(:fetch, _from, queue) do
    with {{:value, item}, new_queue} <- :queue.out(queue) do
      {:reply, item, new_queue}
    else
      {:empty, _} -> {:reply, :empty, queue}
    end
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:reset`
  """
  def handle_call(:reset, _from, _queue) do
    queue = :queue.new
    {:reply, queue, queue}
  end

  @impl true
  @doc """
  Invoked to handle asynchronous callback `cast/2` messages: `:add`
  """
  def handle_cast({:add, item}, queue) do
    {:noreply, :queue.in(item, queue)}
  end

  @impl true
  @doc """
  Invoked to handle asynchronous callback `cast/2` messages: `:update`
  """
  def handle_cast({:update, old_item, new_item}, list) do
    [hd|_] =
      list
      |> Enum.with_index
      |> Enum.filter(fn {n, _} -> n == old_item end)
      |> Enum.map(fn {_, n} -> n end)

    updated = List.replace_at(list, hd, new_item)

    {:noreply, updated}
  end

  @impl true
  @doc """
  Invoked to handle asynchronous callback `cast/2` messages: `:del`
  """
  def handle_cast({:del, item}, queue) do
    updated = queue
              |> :queue.to_list
              |> List.delete(item)
    {:noreply, :queue.from_list(updated)}
  end

  @doc false
  defp terminate(pid) do
    IO.puts("We are all done shopping.")
    # credo:disable-for-next-line
    IO.inspect(show(pid))
    :ok
  end
end
