defmodule GenServerTry.ShopGenstage do
  @moduledoc """
  This is a simple example of setting up a data flow using the GenStage behaviour.
  """

  use GenStage

  @name __MODULE__

  @doc """
  Starts the manager.
  """
  def start_link, do: GenStage.start_link(@name, [], name: @name)

  @doc """
  Show all items from cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenstage.start_link
      iex> GenServerTry.ShopGenstage.show(pid)
      []
  """
  def show(pid), do: GenStage.call(pid, :show)

  @doc """
  Count all items in cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenstage.start_link
      iex> GenServerTry.ShopGenstage.count(pid)
      0
  """
  def count(pid), do: GenStage.call(pid, :count)

  @doc """
  Delete first item from list in cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenstage.start_link
      iex> GenServerTry.ShopGenstage.fetch(pid)
      :ok
  """
  def fetch(pid), do: GenStage.call(pid, :fetch)

  @doc """
  Reset all items and create empty list

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenstage.start_link
      iex> GenServerTry.ShopGenstage.reset(pid)
      []
  """
  def reset(pid), do: GenServer.call(pid, :reset)

  @doc """
  Add item to cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenstage.start_link
      iex> GenServerTry.ShopGenstage.add(pid, "item-1")
      :ok
  """
  def add(pid, item), do: GenStage.cast(pid, {:add, item})

  @doc """
  Update item to new item

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenstage.start_link
      iex> GenServerTry.ShopGenstage.add(pid, "item-1")
      :ok
      iex> GenServerTry.ShopGenstage.update(pid, "item-1", "item-0")
      :ok
  """
  def update(pid, old_item, new_item) do
    GenStage.cast(pid, {:update, old_item, new_item})
  end

  @doc """
  Delete item from cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenstage.start_link
      iex> GenServerTry.ShopGenstage.del(pid, "item-1")
      :ok
  """
  def del(pid, item), do: GenStage.cast(pid, {:del, item})

  @doc """
  Stop Shopping Cart GenServer

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenstage.start_link
      iex> GenServerTry.ShopGenstage.stop(pid)
      :ok
  """
  def stop(pid), do: GenStage.stop(pid, :normal, :infinity)

  @impl true
  @doc """
  Invoked when the server is about to exit. It should do any cleanup required.
  """
  def terminate(_reason, items) do
    IO.puts("We are all done shopping.")
    # credo:disable-for-next-line
    IO.inspect(items)
    :ok
  end

  @impl true
  @doc false
  def init(state), do: {:producer, state}

  @impl true
  @doc false
  def handle_demand(demand, []) when demand == 1 do
    {:noreply, [], []}
  end

  @impl true
  @doc false
  def handle_demand(demand, [head|tail] = list) when demand == 1 do
    if Kernel.length(list) > 0 do
      # strftime_str = Timex.format!(Timex.now, "%H:%M:%S %F", :strftime)
      # IO.puts("#{__MODULE__}::handle_demand @ #{strftime_str}")
      {:noreply, [head], tail}
    else
      {:noreply, [], list}
    end
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:show`
  """
  def handle_call(:show, _from, list) do
    {:reply, list, [], list}
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:count`
  """
  def handle_call(:count, _from, list) do
    counter = Enum.count(list)
    {:reply, counter, [], list}
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:fetch`
  """
  def handle_call(:fetch, _from, list) do
    item = list |> List.first
    updated = Enum.reject(list, &(&1 == item))
    {:reply, :ok, [], updated}
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:reset`
  """
  def handle_call(:reset, _from, _list) do
    list = []
    {:reply, list, [], list}
  end

  @impl true
  @doc """
  Invoked to handle asynchronous callback `cast/2` messages: `:add`
  """
  def handle_cast({:add, item}, list) do
    updated = list ++ [item] |> List.flatten
    {:noreply, [], updated}
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

    {:noreply, [], updated}
  end

  @impl true
  @doc """
  Invoked to handle asynchronous callback `cast/2` messages: `:del`
  """
  def handle_cast({:del, item}, list) do
    updated = Enum.reject(list, &(&1 == item))
    {:noreply, [], updated}
  end
end
