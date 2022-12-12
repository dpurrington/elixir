defmodule MultiMap do
  def new, do: Map.new

  def add_entry(map, key, value) do
    Map.update(map, key, [value], &[key | &1])
  end

  def get(map, key) do
    Map.get(map, key, [])
  end

end
