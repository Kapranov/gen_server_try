defmodule ShopAgentTest do
  use ExUnit.Case
  doctest GenServerTry.ShopAgent

  alias GenServerTry.ShopAgent

  setup do
    {:ok, pid} = ShopAgent.start_link
    %{pid: pid}
  end

  test "shopping starts off empty", %{pid: pid} do
    assert ShopAgent.count(pid) == 0
    assert ShopAgent.show(pid)  == []
  end

  test "add single item", %{pid: pid} do
    ShopAgent.add(pid, "item-1")

    assert ShopAgent.count(pid) == 1
    assert ShopAgent.show(pid)  == ["item-1"]
  end

  test "add multiple items", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopAgent.add(pid, items)

    assert ShopAgent.count(pid) == 3
    assert ShopAgent.show(pid)  == items
  end

  test "add empty list", %{pid: pid} do
    ShopAgent.add(pid, [])

    assert ShopAgent.count(pid) == 0
    assert ShopAgent.show(pid)  == []
  end

  test "add empty without name item", %{pid: pid} do
    ShopAgent.add(pid, "")

    assert ShopAgent.count(pid) == 1
    assert ShopAgent.show(pid)  == [""]
  end

  test "update item to new item", %{pid: pid} do
    ShopAgent.add(pid, "item-1")

    assert ShopAgent.count(pid) == 1
    assert ShopAgent.show(pid)  == ["item-1"]
    assert ShopAgent.update(pid, "item-1", "item-0")  == :ok
    assert ShopAgent.count(pid) == 1
    assert ShopAgent.show(pid)  == ["item-0"]
  end

  test "del some item", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s
    updated = ~w|item-1 item-3|s

    ShopAgent.add(pid, items)
    ShopAgent.del(pid, "item-2")

    assert ShopAgent.count(pid) == 2
    assert ShopAgent.show(pid)  == updated
  end

  test "del empty item without name", %{pid: pid} do
    ShopAgent.add(pid, "item-1")
    ShopAgent.add(pid, "")

    assert ShopAgent.count(pid)   == 2
    assert ShopAgent.del(pid, "") == :ok
    assert ShopAgent.count(pid)   == 1
    assert ShopAgent.show(pid)    == ["item-1"]
  end

  test "fetch returns correct item", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s
    updated = ~w|item-2 item-3|s

    ShopAgent.add(pid, items)

    assert ShopAgent.count(pid) == 3
    assert ShopAgent.fetch(pid) == :ok
    assert ShopAgent.count(pid) == 2
    assert ShopAgent.show(pid)  == updated
  end

  test "fetch returns empty list if list is empty", %{pid: pid} do
    assert ShopAgent.count(pid) == 0
    assert ShopAgent.show(pid)  == []
    assert ShopAgent.fetch(pid) == :ok
    assert ShopAgent.count(pid) == 0
    assert ShopAgent.show(pid)  == []
  end

  test "reset returns empty list", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopAgent.add(pid, items)

    assert ShopAgent.count(pid) == 3
    assert ShopAgent.show(pid)  == items
    assert ShopAgent.reset(pid) == []
    assert ShopAgent.count(pid) == 0
    assert ShopAgent.show(pid)  == []
  end

  test "stop genserver and return last items", %{pid: pid} do
    items = ~w|item-1 item-2 item-3|s

    ShopAgent.add(pid, items)

    assert ShopAgent.stop(pid) == :ok
    assert Process.alive?(pid)     == false
  end

  test "nil name", %{pid: pid} do
    assert Process.info(pid, :registered_name) == {:registered_name, []}
  end
end
