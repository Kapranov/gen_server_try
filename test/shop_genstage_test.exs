defmodule ShopGenstageTest do
  use ExUnit.Case
  doctest GenServerTry.ShopGenstage

  alias GenServerTry.{GoodsGenstage, ShopGenstage}

  test "shopping starts off empty" do
    {:ok, pid} = ShopGenstage.start_link

    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid) == []
  end

  test "add single item" do
    {:ok, pid} = ShopGenstage.start_link

    ShopGenstage.add(pid, "item-1")

    assert ShopGenstage.count(pid) == 1
    assert ShopGenstage.show(pid)  == ["item-1"]
  end

  test "add multiple items" do
    {:ok, pid} = ShopGenstage.start_link

    items = ~w|item-3 item-2 item-1|s

    ShopGenstage.add(pid, items)

    assert ShopGenstage.count(pid) == 3
    assert ShopGenstage.show(pid)  == items
  end

  test "add empty list" do
    {:ok, pid} = ShopGenstage.start_link

    ShopGenstage.add(pid, [])

    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid)  == []
  end

  test "add empty without name item" do
    {:ok, pid} = ShopGenstage.start_link

    ShopGenstage.add(pid, "")

    assert ShopGenstage.count(pid) == 1
    assert ShopGenstage.show(pid)  == [""]
  end

  test "update item" do
    {:ok, pid} = ShopGenstage.start_link

    ShopGenstage.add(pid, "item-1")

    assert ShopGenstage.count(pid) == 1
    assert ShopGenstage.show(pid)  == ["item-1"]
    assert ShopGenstage.update(pid, "item-1", "item-0")  == :ok
    assert ShopGenstage.count(pid) == 1
    assert ShopGenstage.show(pid)  == ["item-0"]
  end

  test "del some item" do
    {:ok, pid} = ShopGenstage.start_link

    items = ~w|item-3 item-2 item-1|s
    updated = ~w|item-3 item-1|s

    ShopGenstage.add(pid, items)
    ShopGenstage.del(pid, "item-2")

    assert ShopGenstage.count(pid) == 2
    assert ShopGenstage.show(pid)  == updated
  end

  test "del empty item without name" do
    {:ok, pid} = ShopGenstage.start_link

    ShopGenstage.add(pid, "item-1")
    ShopGenstage.add(pid, "")

    assert ShopGenstage.count(pid)   == 2
    assert ShopGenstage.del(pid, "") == :ok
    assert ShopGenstage.count(pid)   == 1
    assert ShopGenstage.show(pid)    == ["item-1"]
  end

  test "fetch returns correct item" do
    {:ok, pid} = ShopGenstage.start_link

    items = ~w|item-3 item-2 item-1|s
    updated = ~w|item-2 item-1|s

    ShopGenstage.add(pid, items)

    assert ShopGenstage.count(pid) == 3
    assert ShopGenstage.fetch(pid) == :ok
    assert ShopGenstage.count(pid) == 2
    assert ShopGenstage.show(pid)  == updated
  end

  test "fetch returns empty list if list is empty" do
    {:ok, pid} = ShopGenstage.start_link

    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid)  == []
    assert ShopGenstage.fetch(pid) == :ok
    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid)  == []
  end

  test "reset returns empty list" do
    {:ok, pid} = ShopGenstage.start_link

    items = ~w|item-3 item-2 item-1|s

    ShopGenstage.add(pid, items)

    assert ShopGenstage.count(pid) == 3
    assert ShopGenstage.show(pid)  == items
    assert ShopGenstage.reset(pid) == []
    assert ShopGenstage.count(pid) == 0
    assert ShopGenstage.show(pid)  == []
  end

  test "stop genserver and return last items" do
    {:ok, pid} = ShopGenstage.start_link

    items = ~w|item-3 item-2 item-1|s

    ShopGenstage.add(pid, items)

    assert ShopGenstage.stop(pid) == :ok
    assert Process.alive?(pid)     == false
  end

  test "check out function run" do
    assert {:ok, _} = ShopGenstage.run
  end

  test "producer and consumer work together" do
    {:ok, shop} = ShopGenstage.start_link
    {:ok, goods} = GoodsGenstage.start_link

    ShopGenstage.add(shop, "item-1")
    ShopGenstage.add(shop, "item-2")
    ShopGenstage.add(shop, "item-3")

    GenStage.sync_subscribe(goods, to: shop, max_demand: 1)

    ShopGenstage.add(shop, "item-4")
    ShopGenstage.add(shop, "item-5")
    ShopGenstage.add(shop, "item-6")

    Process.sleep(6000)

    assert ShopGenstage.show(shop) == []
  end

  test "producer and consumer work together with array queue" do
    {:ok, shop} = ShopGenstage.start_link
    {:ok, goods} = GoodsGenstage.start_link

    items_1 = ~w(item-1 item-2 item-3)
    items_2 = ~w(item-4 item-5 item-6)

    ShopGenstage.add(shop, items_1)

    GenStage.sync_subscribe(goods, to: shop, max_demand: 1)

    ShopGenstage.add(shop, items_2)

    Process.sleep(6000)

    assert ShopGenstage.show(shop) == []
  end

  test "nil name" do
    {:ok, pid} = ShopGenstage.start_link

    assert Process.info(pid, :registered_name) == {:registered_name, GenServerTry.ShopGenstage}
  end
end
