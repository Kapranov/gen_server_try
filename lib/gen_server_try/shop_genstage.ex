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
end
