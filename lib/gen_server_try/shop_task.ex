defmodule GenServerTry.ShopTask do
  @moduledoc """
  Conveniences for spawning and awaiting tasks.

  Tasks are processes meant to execute one particular
  action throughout their lifetime, often with little or no
  communication with other processes. The most common use case
  for tasks is to convert sequential code into concurrent code
  by computing a value asynchronously.

  Tasks provide a way to execute a function in the background
  and retrieve its return value later. They can be particularly
  useful when handling expensive operations without blocking
  the application execution.
  """

  use Task

  @name __MODULE__
  @items ~w("item-1", "item-2", "item-3")

  @doc """
  `Task.start/1` and `Task.start_link/1` which return `{:ok, pid}`
  rather than just the PID.

  #Example

      iex> {:ok, pid} = GenServerTry.ShopTask.start_link
      iex> Process.alive?(pid)
      true
  """
  def start_link, do: Task.start_link(@name, :show, [])

  @doc """
  Show all items in local memory

  #Example

      iex> GenServerTry.ShopTask.show
      :ok
  """
  def show do
    :timer.sleep(500)
    IO.puts(@items)
  end
end
