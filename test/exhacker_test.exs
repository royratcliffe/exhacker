defmodule ExhackerTest do
  use ExUnit.Case
  doctest Exhacker

  test "greets the world" do
    assert Exhacker.hello() == :world
  end
end
