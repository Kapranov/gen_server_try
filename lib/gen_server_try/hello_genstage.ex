defmodule GenServerTry.HelloGenstage do
  @moduledoc """
  GenStage example that contains a Producer, ProducerConsumer, and
  a Consumer.

  It does not need ti implement `handle_demand` because the demand
  is always forwarded from the original `Producer` through `GenStage.sync_subscribe`
  """

  alias GenServerTry.{GoodsGenstage, ItemsGenstage, ShopGenstage}

  @max 1
  @step 2
  @steps 1..9
  @goods ~w(item-1 item-2 item-3 item-4 item-5 item-6 item-7 item-8 item-9)

  @doc """
  A basic Producer-ProducerConsumer-Consumer example of GenStage

  We create one producer and initialize its state with a list of 9,
  a ProducerConsumer that will consume events (the list of 9) from the first producer,
  double them, and pass those events down to the final Consumer.
  We set up the stages Events will flow from the Producer to the ProducerConsumer
  and finally to the Consumer `producer` --> `producer_consumer` --> `consumer`
  `consumer` will request events from `producer_consumer` and
  `producer_consumer` will request from `producer`

  # Example

      iex> HelloGenstage.run
  """
  def run do
    things_to_process =
      (@steps)
      |> Enum.to_list

    {:ok, producer} = GenStage.start_link(ShopGenstage, things_to_process)
    {:ok, producer_consumer} = GenStage.start_link(ItemsGenstage, :no_state)
    {:ok, consumer} = GenStage.start_link(GoodsGenstage, :no_state)

    GenStage.sync_subscribe(consumer, to: producer_consumer, max_demand: @max)
    GenStage.sync_subscribe(producer_consumer, to: producer, max_demand: @max)
  end

  @doc """
  A basic Producer-ProducerConsumer-Consumer example of GenStage

  We create one producer and initialize its state with a list of 9,
  a ProducerConsumer that will consume events (the list of 9) from the first producer,
  double them, and pass those events down to the final Consumer.
  We set up the stages Events will flow from the Producer to the ProducerConsumer
  and finally to the Consumer `producer` --> `producer_consumer` --> `consumer`
  `consumer` will request events from `producer_consumer` and
  `producer_consumer` will request from `producer`

  # Example

      iex> HelloGenstage.go
  """
  def go do
    items_to_process =
      (@goods)
      |> Enum.to_list

    {:ok, producer} = GenStage.start_link(ShopGenstage, items_to_process)
    {:ok, producer_consumer} = GenStage.start_link(ItemsGenstage, :no_state)
    {:ok, consumer} = GenStage.start_link(GoodsGenstage, :no_state)

    GenStage.sync_subscribe(consumer, to: producer_consumer, max_demand: @step)
    GenStage.sync_subscribe(producer_consumer, to: producer, max_demand: @step)
  end
end
