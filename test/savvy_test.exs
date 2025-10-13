defmodule SavvyTest do
  use ExUnit.Case
  doctest Savvy

  test "greets the world" do
    assert Savvy.hello() == :world
  end
end
