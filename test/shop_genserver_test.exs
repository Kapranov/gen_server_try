defmodule ShopGenserverTest do
  use ExUnit.Case
  doctest GenServerTry.ShopGenserver

  alias GenServerTry.ShopGenserver

  setup do
    {:ok, pid} = ShopGenserver.start_link
    %{pid: pid}
  end

  test "shopping starts off empty", %{pid: pid} do
    assert ShopGenserver.count(pid) == 0
    assert ShopGenserver.show(pid)  == []
  end

  test "add single item", %{pid: pid} do
    ShopGenserver.add(pid, "item-1")

    assert ShopGenserver.count(pid) == 1
    assert ShopGenserver.show(pid)  == ["item-1"]
  end

  test "add multiple items", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopGenserver.add(pid, items)

    assert ShopGenserver.count(pid) == 3
    assert ShopGenserver.show(pid)  == items
  end

  test "add empty list", %{pid: pid} do
    ShopGenserver.add(pid, [])

    assert ShopGenserver.count(pid) == 0
    assert ShopGenserver.show(pid)  == []
  end

  test "add empty without name item", %{pid: pid} do
    ShopGenserver.add(pid, "")

    assert ShopGenserver.count(pid) == 1
    assert ShopGenserver.show(pid)  == [""]
  end

  test "del some item", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s
    updated = ~w|item-1 item-3|s

    ShopGenserver.add(pid, items)
    ShopGenserver.del(pid, "item-2")

    assert ShopGenserver.count(pid) == 2
    assert ShopGenserver.show(pid)  == updated
  end

  test "del empty item without name", %{pid: pid} do
    ShopGenserver.add(pid, "item-1")
    ShopGenserver.add(pid, "")

    assert ShopGenserver.count(pid)   == 2
    assert ShopGenserver.del(pid, "") == :ok
    assert ShopGenserver.count(pid)   == 1
    assert ShopGenserver.show(pid)    == ["item-1"]
  end

  test "fetch returns correct item", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s
    updated = ~w|item-2 item-3|s

    ShopGenserver.add(pid, items)

    assert ShopGenserver.count(pid) == 3
    assert ShopGenserver.fetch(pid) == :ok
    assert ShopGenserver.count(pid) == 2
    assert ShopGenserver.show(pid)  == updated
  end

  test "fetch returns empty list if list is empty", %{pid: pid} do
    assert ShopGenserver.count(pid) == 0
    assert ShopGenserver.show(pid)  == []
    assert ShopGenserver.fetch(pid) == :ok
    assert ShopGenserver.count(pid) == 0
    assert ShopGenserver.show(pid)  == []
  end

  test "reset returns empty list", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopGenserver.add(pid, items)

    assert ShopGenserver.count(pid) == 3
    assert ShopGenserver.show(pid)  == items
    assert ShopGenserver.reset(pid) == []
    assert ShopGenserver.count(pid) == 0
    assert ShopGenserver.show(pid)  == []
  end

  test "stop genserver and return last items", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopGenserver.add(pid, items)

    assert ShopGenserver.stop(pid) == :ok
    assert Process.alive?(pid)     == false
  end

  test "nil name", %{pid: pid} do
    assert Process.info(pid, :registered_name) == {:registered_name, []}
  end
end
