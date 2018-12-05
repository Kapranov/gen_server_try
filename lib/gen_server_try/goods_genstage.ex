defmodule GenServerTry.GoodsGenstage do
  @moduledoc false

  use GenStage

  @name __MODULE__

  @doc false
  def start_link, do: GenStage.start_link(@name, :nothing)

  @impl true
  @doc false
  def init(state), do: {:consumer, state}

  @impl true
  @doc false
  def handle_events(goods, _from, state) do
    {:noreply, goods, state}
  end
end
