defmodule GenServerTryTest do
  use ExUnit.Case
  doctest GenServerTry

  test "greets the world" do
    assert GenServerTry.hello() == :world
  end
end
