defmodule GenServerTry.GoodsGenstage do
  @moduledoc false

  use GenStage

  @name __MODULE__

  @doc false
  def start_link, do: GenStage.start_link(@name, :nothing)

  @doc false
  def init(state), do: {:consumer, state}
end
