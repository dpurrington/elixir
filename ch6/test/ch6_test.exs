defmodule Ch6Test do
  use ExUnit.Case
  doctest Ch6

  test "greets the world" do
    assert Ch6.hello() == :world
  end
end
