defmodule GenServerTry.ItemsGenstage do
  @moduledoc """
  A GenStage Producer and Consumer.

  It does not need ti implement `handle_demand` because the demand
  is always forwarded from the original `Producer` through `GenStage.sync_subscribe`
  """

  use GenStage

  @doc false
  def init(:no_state), do: {:producer_consumer, :no_state}

  @doc """
  `handle_events` is the callback Consumers and ProducerConsumer must implement.
  `sleep` - Sleep so it looks like we are doing more things. Then print events
  to terminal. Do the doubling and the buttom of line print events to terminal.
  """
  def handle_events(events, _from, :no_state) do
    :timer.sleep(1000)
    IO.puts("ProducerConsumer - Received #{Kernel.length(events)} events - #{inspect(events, charlists: :as_lists)}")
    events = Enum.map(events , &(&1))
    IO.puts("ProducerConsumer - Doubles each element, now producing #{inspect(events, charlists: :as_lists)}")
    {:noreply, events, :no_state}
  end
end
