defmodule GenServerTry.ShopTask do
  @moduledoc """
  Conveniences for spawning and awaiting tasks.

  Tasks are processes meant to execute one particular
  action throughout their lifetime, often with little or no
  communication with other processes. The most common use case
  for tasks is to convert sequential code into concurrent code
  by computing a value asynchronously.
  """

  use Task

  @name __MODULE__

  @doc false
  def start_link, do: Task.start_link(@name, :show, [])

  @doc """
  Show all items in memory

  #Example

      iex> {:ok, pid} = GenServerTry.ShopTask.start_link
      :ok
  """
  def show do
    {:ok, "Show all items"}
  end
end
