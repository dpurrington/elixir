defmodule Ch5Test do
  use ExUnit.Case
  doctest Ch5

  test "greets the world" do
    assert Ch5.hello() == :world
  end
end
