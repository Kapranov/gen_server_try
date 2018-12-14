defmodule GenServerTry.ItemsGenstage do
  @moduledoc """
  A GenStage Producer and Consumer.

  It does not need ti implement `handle_demand` because the demand
  is always forwarded from the original `Producer` through `GenStage.sync_subscribe`
  """

  use GenStage

  @doc false
  def init(_), do: {:producer_consumer, :nothing}

  @doc """
  `handle_events` is the callback Consumers and ProducerConsumer must implement.
  `sleep` - Sleep so it looks like we are doing more things. Then print events
  to terminal. Do the doubling and the buttom of line print events to terminal.
  """
  def handle_events(events, _from, state) do
    :timer.sleep(1000)

    # credo:disable-for-next-line
    IO.inspect(events, charlists: :as_lists, label: "ProducerConsumer - Received #{Kernel.length(events)} events")

    events = Enum.map(events , &(&1))

    {:noreply, events, state}
  end
end
