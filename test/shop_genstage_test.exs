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
    items = ~w|item-3 item-2 item-1|s

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

  test "update item", %{pid: pid} do
    ShopGenstage.add(pid, "item-1")

    assert ShopGenstage.count(pid) == 1
    assert ShopGenstage.show(pid)  == ["item-1"]
    assert ShopGenstage.update(pid, "item-1", "item-0")  == :ok
    assert ShopGenstage.count(pid) == 1
    assert ShopGenstage.show(pid)  == ["item-0"]
  end

  test "del some item", %{pid: pid} do
    items = ~w|item-3 item-2 item-1|s
    updated = ~w|item-3 item-1|s

    ShopGenstage.add(pid, items)
    ShopGenstage.del(pid, "item-2")

    assert ShopGenstage.count(pid) == 2
    assert ShopGenstage.show(pid)  == updated
  end

  test "del empty item without name", %{pid: pid} do
    ShopGenstage.add(pid, "item-1")
    ShopGenstage.add(pid, "")

    assert ShopGenstage.count(pid)   == 2
    assert ShopGenstage.del(pid, "") == :ok
    assert ShopGenstage.count(pid)   == 1
    assert ShopGenstage.show(pid)    == ["item-1"]
  end

  test "fetch returns correct item", %{pid: pid} do
    items = ~w|item-3 item-2 item-1|s
    updated = ~w|item-2 item-1|s

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

  test "reset returns empty list", %{pid: pid} do
    items = ~w|item-3 item-2 item-1|s

    ShopGenstage.add(pid, items)

    assert ShopGenstage.count(pid) == 3
    assert ShopGenstage.show(pid)  == items
    assert ShopGenstage.reset(pid) == []
    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid)  == []
  end

  test "stop genserver and return last items", %{pid: pid} do
    items = ~w|item-3 item-2 item-1|s

    ShopGenstage.add(pid, items)

    assert ShopGenstage.stop(pid) == :ok
    assert Process.alive?(pid)     == false
  end

  test "nil name", %{pid: pid} do
    assert Process.info(pid, :registered_name) == {:registered_name, GenServerTry.ShopGenstage}
  end
end
