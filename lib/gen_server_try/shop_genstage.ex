defmodule GenServerTry.ShopGenstage do
  @moduledoc """
  This is a simple example of setting up a data flow using the GenStage behaviour.
  """

  use GenStage

  @name __MODULE__

  @doc false
  def start_link(args \\ 0), do: GenStage.start_link(@name, args, name: @name)

  @doc false
  def init(args), do: {:producer, args}

  @doc false
  def handle_demand(demand, state) do
    events = Enum.to_list(state..(state + demand - 1))
    {:noreply, events, state + demand}
  end
end
