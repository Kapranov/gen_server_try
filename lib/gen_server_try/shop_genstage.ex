defmodule GenServerTry.ShopGenstage do
  @moduledoc """
  This is a simple example of setting up a data flow using the GenStage behaviour.
  """

  use GenStage

  @name __MODULE__

  @doc """
  Starts the manager.
  """
  def start_link, do: GenStage.start_link(@name, [])

  @doc false
  def show(pid), do: GenStage.call(pid, :show)

  @doc false
  def count(pid), do: GenStage.call(pid, :count)

  @doc false
  def init(state), do: {:producer, state}

  @doc false
  def handle_call(:show, _from, list) do
    {:reply, list, [], list}
  end

  @doc false
  def handle_call(:count, _from, list) do
    counter = Enum.count(list)
    {:reply, counter, [], list}
  end
end