defmodule ExHackerTest do
  use ExUnit.Case
  doctest ExHacker

  test "matrix dimensions" do
    assert ExHacker.mat_dim([]) == {0, 0}
    assert ExHacker.mat_dim([[]]) == {0, 1}
    assert ExHacker.mat_dim([[:a], [:b], [:c]]) == {1, 3}
  end
end
