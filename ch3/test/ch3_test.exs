defmodule Ch3Test do
  use ExUnit.Case
  doctest Ch3

  test "greets the world" do
    assert Ch3.hello() == :world
  end
end
