defmodule Ch4Test do
  use ExUnit.Case
  doctest Ch4

  test "greets the world" do
    assert Ch4.hello() == :world
  end
end
