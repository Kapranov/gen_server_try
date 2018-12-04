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

  @doc false
  def show(pid), do: GenStage.call(pid, :show)

  @doc false
  def count(pid), do: GenStage.call(pid, :count)

  @doc false
  def fetch(pid), do: GenStage.call(pid, :fetch)

  @doc false
  def add(pid, item), do: GenStage.cast(pid, {:add, item})

  @doc false
  def update(pid, old_item, new_item) do
    GenStage.cast(pid, {:update, old_item, new_item})
  end

  @doc false
  def del(pid, item), do: GenStage.cast(pid, {:del, item})

  @impl true
  @doc false
  def init(state), do: {:producer, state}

  @impl true
  @doc false
  def handle_call(:show, _from, list) do
    {:reply, list, [], list}
  end

  @impl true
  @doc false
  def handle_call(:count, _from, list) do
    counter = Enum.count(list)
    {:reply, counter, [], list}
  end

  @impl true
  @doc false
  def handle_call(:fetch, _from, list) do
    item = list |> List.first
    updated = Enum.reject(list, &(&1 == item))
    {:reply, :ok, [], updated}
  end

  @impl true
  @doc false
  def handle_cast({:add, item}, list) do
    updated = [item|list] |> List.flatten
    {:noreply, [], updated}
  end

  @doc false
  def handle_cast({:update, old_item, new_item}, list) do
    [hd|_] =
      list
      |> Enum.with_index
      |> Enum.filter(fn {n, _} -> n == old_item end)
      |> Enum.map(fn {_, n} -> n end)

    updated = List.replace_at(list, hd, new_item)

    {:noreply, [], updated}
  end

  @doc false
  def handle_cast({:del, item}, list) do
    updated = Enum.reject(list, &(&1 == item))
    {:noreply, [], updated}
  end
end
