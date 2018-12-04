defmodule ShopGenstageTest do
  use ExUnit.Case
  doctest GenServerTry.ShopGenstage

  alias GenServerTry.ShopGenstage

  setup do
    {:ok, pid} = ShopGenstage.start_link
    %{pid: pid}
  end

  test "shopping starts off empty", %{pid: pid} do
    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid) == []
  end
end
