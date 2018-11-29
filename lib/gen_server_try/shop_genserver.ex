defmodule GenServerTry.ShopGenserver do
  @moduledoc """
  Implementation Shopping Cart by OTP GenServer.

  A GenServer is a process like any other Elixir process and it can be used
  to keep state, execute code asynchronously and so on. The advantage of using
  a generic server process (GenServer) implemented using this module is that it
  will have a standard set of interface functions and include functionality for
  tracing and error reporting. It will also fit into a supervision tree.
  """

  use GenServer

  @name __MODULE__

  @doc """
  Starts a `GenServer` process linked to the current process.
  """
  def start_link, do: GenServer.start_link(@name, [])

  @doc """
  Show all items from cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenserver.start_link
      iex> GenServerTry.ShopGenserver.show(pid)
      []
  """
  def show(pid), do: GenServer.call(pid, :show)

  @doc """
  Count all items in cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenserver.start_link
      iex> GenServerTry.ShopGenserver.count(pid)
      0
  """
  def count(pid), do: GenServer.call(pid, :count)

  @doc """
  Delete first item from list in cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenserver.start_link
      iex> GenServerTry.ShopGenserver.fetch(pid)
      :ok
  """
  def fetch(pid), do: GenServer.call(pid, :fetch)

  @doc """
  Reset all items and create empty list

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenserver.start_link
      iex> GenServerTry.ShopGenserver.reset(pid)
      []
  """
  def reset(pid), do: GenServer.call(pid, :reset)

  @doc """
  Add item to cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenserver.start_link
      iex> GenServerTry.ShopGenserver.add(pid, "item-1")
      :ok
  """
  def add(pid, item), do: GenServer.cast(pid, {:add, item})

  @doc """
  Delete item from cart

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenserver.start_link
      iex> GenServerTry.ShopGenserver.del(pid, "item-1")
      :ok
  """
  def del(pid, item), do: GenServer.cast(pid, {:del, item})

  @doc """
  Stop Shopping Cart GenServer

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopGenserver.start_link
      iex> GenServerTry.ShopGenserver.stop(pid)
      :ok
  """
  def stop(pid), do: GenServer.stop(pid, :normal, :infinity)

  @impl true
  @doc """
  Invoked when the server is about to exit. It should do any cleanup required.
  """
  def terminate(_reason, list) do
    IO.puts("We are all done shopping.")
    # credo:disable-for-next-line
    IO.inspect(list)
    :ok
  end

  @impl true
  @doc false
  def init(args), do: {:ok, args}

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:show`
  """
  def handle_call(:show, _from, list) do
    sorted = list |> Enum.sort
    {:reply, sorted, list}
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:count`
  """
  def handle_call(:count, _from, list) do
    counter = list |> length
    {:reply, counter, list}
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:fetch`
  """
  def handle_call(:fetch, _from, list) do
    item = list |> List.first
    updated = Enum.reject(list, &(&1 == item))
    {:reply, :ok, updated}
  end

  @impl true
  @doc """
  Invoked to handle synchronous callback `call/3` messages: `:reset`
  """
  def handle_call(:reset, _from, _list) do
    list = []
    {:reply, list, list}
  end

  @impl true
  @doc """
  Invoked to handle asynchronous callback `cast/2` messages: `:add`
  """
  def handle_cast({:add, item}, list) do
    updated = [item|list] |> List.flatten
    {:noreply, updated}
  end

  @impl true
  @doc """
  Invoked to handle asynchronous callback `cast/2` messages: `:del`
  """
  def handle_cast({:del, item}, list) do
    updated = Enum.reject(list, &(&1 == item))
    {:noreply, updated}
  end
end
