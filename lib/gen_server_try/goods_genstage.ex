defmodule GenServerTry.GoodsGenstage do
  @moduledoc """
  A simple GenStage Consumer stage
  """

  use GenStage

  @name __MODULE__

  @doc false
  def start_link, do: GenStage.start_link(@name, :nothing)

  @impl true
  @doc false
  def init(_), do: {:consumer, :nothing}

  @impl true
  @doc """
  `handle_events` is the callback Consumers must implement

  Arguments:

  - `events` - a list of "things" that have been requested to consume
  - `from` - the producer(?)
  - `state` - in this case we have set the state to `:no_state` in `init`

  `sleep` -  Sleep so it looks like we are doing more things and then
  print events to terminal and the buttom line we are a consumer,
  so we never emit events.

  You can set `events = Enum.map(events , &(&1 <> " PAID"))`.
  """
  def handle_events(events, _from, state) do
    Process.sleep(1000)

    # credo:disable-for-next-line
    IO.inspect(events, charlists: :as_lists, label: "Consumer - Received")

    {:noreply, [], state}
  end
end
