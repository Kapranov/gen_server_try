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

  test "fetch returns empty list if list is empty", %{pid: pid} do
    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid)  == []
    assert ShopGenstage.fetch(pid) == :ok
    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid)  == []
  end

  test "nil name", %{pid: pid} do
    assert Process.info(pid, :registered_name) == {:registered_name, GenServerTry.ShopGenstage}
  end
end
