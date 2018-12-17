defmodule ShopTaskTest do
  use ExUnit.Case
  # doctest GenServerTry.ShopTaskTest

  alias GenServerTry.{ShopTask}

  test "shopping starts off empty" do
    assert ShopTask.show == {:ok, "Show all items"}
  end
end
