defmodule ShopQueueTest do
  use ExUnit.Case
  doctest GenServerTry.ShopQueue

  alias GenServerTry.ShopQueue

  setup do
    {:ok, pid} = ShopQueue.start_link
    %{pid: pid}
  end

  test "shopping starts off empty", %{pid: pid} do
    assert ShopQueue.count(pid) == 0
    assert ShopQueue.show(pid)  == []
  end

  test "add single item", %{pid: pid} do
    ShopQueue.add(pid, "item-1")

    assert ShopQueue.count(pid) == 1
    assert ShopQueue.show(pid)  == ["item-1"]
  end

  test "add multiple items", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopQueue.add(pid, items)

    assert ShopQueue.count(pid) == 3
    assert ShopQueue.show(pid)  == items
  end

  test "add empty list", %{pid: pid} do
    ShopQueue.add(pid, [])

    assert ShopQueue.count(pid) == 0
    assert ShopQueue.show(pid)  == []
  end

  test "add empty without name item", %{pid: pid} do
    ShopQueue.add(pid, "")

    assert ShopQueue.count(pid) == 1
    assert ShopQueue.show(pid)  == [""]
  end

  test "update item to new item", %{pid: pid} do
    ShopQueue.add(pid, "item-1")

    assert ShopQueue.count(pid) == 1
    assert ShopQueue.show(pid)  == ["item-1"]
    assert ShopQueue.update(pid, "item-1", "item-0")  == :ok
    assert ShopQueue.count(pid) == 1
    assert ShopQueue.show(pid)  == ["item-0"]
  end

  test "del some item", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s
    updated = ~w|item-1 item-3|s

    ShopQueue.add(pid, items)
    ShopQueue.del(pid, "item-2")

    assert ShopQueue.count(pid) == 2
    assert ShopQueue.show(pid)  == updated
  end

  test "del empty item without name", %{pid: pid} do
    ShopQueue.add(pid, "item-1")
    ShopQueue.add(pid, "")

    assert ShopQueue.count(pid)   == 2
    assert ShopQueue.del(pid, "") == :ok
    assert ShopQueue.count(pid)   == 1
    assert ShopQueue.show(pid)    == ["item-1"]
  end

  test "fetch returns correct item", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s
    updated = ~w|item-2 item-3|s

    ShopQueue.add(pid, items)

    assert ShopQueue.count(pid) == 3
    assert ShopQueue.fetch(pid) == "item-1"
    assert ShopQueue.count(pid) == 2
    assert ShopQueue.show(pid)  == updated
  end

  test "fetch returns empty list if list is empty", %{pid: pid} do
    assert ShopQueue.count(pid) == 0
    assert ShopQueue.show(pid)  == []
    assert ShopQueue.fetch(pid) == []
    assert ShopQueue.count(pid) == 0
    assert ShopQueue.show(pid)  == []
  end

  test "reset returns empty list", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopQueue.add(pid, items)

    assert ShopQueue.count(pid) == 3
    assert ShopQueue.show(pid)  == items
    assert ShopQueue.reset(pid) == []
    assert ShopQueue.count(pid) == 0
    assert ShopQueue.show(pid)  == []
  end

  test "stop genserver and return last items", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopQueue.add(pid, items)

    assert ShopQueue.stop(pid) == :ok
    assert Process.alive?(pid)     == false
  end

  test "nil name", %{pid: pid} do
    assert Process.info(pid, :registered_name) == {:registered_name, []}
  end
end
