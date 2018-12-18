defmodule ShopTaskTest do
  use ExUnit.Case
  doctest GenServerTry.ShopTask

  alias GenServerTry.ShopTask

  test "start process and die" do
    {:ok, pid} = ShopTask.start_link
    assert Process.alive?(pid) == true
  end

  test "shopping starts off" do
    assert ShopTask.show == :ok
  end

  test "parallelizing with async/await" do
    task = Task.async(GenServerTry.ShopTask, :show, [])
    ref  = Process.monitor(task.pid)

    assert Task.await(task) == :ok
    assert_receive {:DOWN, ^ref, :process, _, :normal}, 500
  end
end
