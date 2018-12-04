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

  test "add single item", %{pid: pid} do
    ShopGenstage.add(pid, "item-1")

    assert ShopGenstage.count(pid) == 1
    assert ShopGenstage.show(pid)  == ["item-1"]
  end

  test "add multiple items", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopGenstage.add(pid, items)

    assert ShopGenstage.count(pid) == 3
    assert ShopGenstage.show(pid)  == items
  end

  test "add empty list", %{pid: pid} do
    ShopGenstage.add(pid, [])

    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid)  == []
  end

  test "add empty without name item", %{pid: pid} do
    ShopGenstage.add(pid, "")

    assert ShopGenstage.count(pid) == 1
    assert ShopGenstage.show(pid)  == [""]
  end

  test "fetch returns correct item", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s
    updated = ~w|item-2 item-3|s

    ShopGenstage.add(pid, items)

    assert ShopGenstage.count(pid) == 3
    assert ShopGenstage.fetch(pid) == :ok
    assert ShopGenstage.count(pid) == 2
    assert ShopGenstage.show(pid)  == updated
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
