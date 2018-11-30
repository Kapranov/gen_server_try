defmodule GenServerTry.ShopAgent do
  @moduledoc """
  Agents are a simple abstraction around state.

  Often in Elixir there is a need to share or store state that
  must be accessed from different processes or by the same process
  at different points in time.

  The `Agent` module provides a basic server implementation that
  allows state to be retrieved and updated via a simple API.
  """

  @doc """
  Starts an agent linked to the current process with the given function.
  """
  def start_link, do: Agent.start_link(fn -> [] end)

  @doc """
  Show all items from cart.
  Gets an agent value via the given function.

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopAgent.start_link
      iex> GenServerTry.ShopAgent.show(pid)
      []
  """
  def show(pid), do: Agent.get(pid, &(&1))

  @doc """
  Count all items in cart.
  Gets an agent value via the given function.

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopAgent.start_link
      iex> GenServerTry.ShopAgent.count(pid)
      0
  """
  def count(pid), do: Agent.get(pid, &Enum.count/1)

  @doc """
  Delete first item from list in cart.
  Gets and updates the agent state in one operation via the given function.

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopAgent.start_link
      iex> GenServerTry.ShopAgent.fetch(pid)
      :ok
  """
  def fetch(pid) do
    Agent.update(pid, fn(items) ->
      items
      |> Enum.reject(&(&1 == List.first(items)))
    end)
  end

  @doc """
  Reset all items and create empty list
  Gets an agent value via the given function.

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopAgent.start_link
      iex> GenServerTry.ShopAgent.reset(pid)
      []
  """
  def reset(pid) do
    Agent.get_and_update(pid, fn _state -> {[], []} end)
  end

  @doc """
  Add item to cart.
  Gets an agent value via the given function.

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopAgent.start_link
      iex> GenServerTry.ShopAgent.add(pid, "item-1")
      :ok
  """
  def add(pid, item) do
    Agent.update(pid, &([item | &1] |> List.flatten))
  end

  @doc"""
  Update item to new item
  Gets an agent value via the given function.

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopAgent.start_link
      iex> GenServerTry.ShopAgent.add(pid, "item-1")
      :ok
      iex> GenServerTry.ShopAgent.update(pid, "item-1", "item-0")
      :ok
  """
  def update(pid, old_item, new_item) do
    Agent.update(pid, fn items ->
      [hd|_] = items
                |> Enum.with_index
                |> Enum.filter(fn {n, _} -> n == old_item end)
                |> Enum.map(fn {_, n} -> n end)

      List.replace_at(items, hd, new_item)
    end)
  end

  @doc """
  Delete item from cart.
  Gets an agent value via the given function.

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopAgent.start_link
      iex> GenServerTry.ShopAgent.add(pid, "item-1")
      :ok
  """
  def del(pid, item), do: Agent.update(pid, &List.delete(&1, item))

  @doc """
  Synchronously stops the agent with the given `reason`.

  ## Example

      iex> {:ok, pid} = GenServerTry.ShopAgent.start_link
      iex> GenServerTry.ShopAgent.stop(pid)
      :ok
  """
  def stop(pid) do
    terminate(pid)
    Agent.stop(pid, :normal, :infinity)
  end

  @doc false
  defp terminate(pid) do
    items = Agent.get(pid, &(&1))
    IO.puts("We are all done shopping.")
    # credo:disable-for-next-line
    IO.inspect(items)
    :ok
  end
end
