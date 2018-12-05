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
  def handle_events(events, _from, state) do
    # credo:disable-for-next-line
    IO.inspect(events, label: "Events being processed")
    Process.sleep(1000)
    {:noreply, [], state}
  end
end
