defmodule Ch3 do
  @moduledoc """
  Documentation for `Ch3`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Ch3.hello()
      :world

  """
  def hello do
    :world
  end
end
defmodule NaturalNums do
  def print(1), do: IO.puts(1)

  def print(n) when n > 1 do
    print(n-1)
    IO.puts(n)
  end

  def print(0), do: IO.puts(0)
end
defmodule Summer do
  def sum(list, acc \\ 0)
  def sum([], acc), do: acc
  def sum([head | tail], acc), do: sum(tail, head+acc)
end
defmodule Recurse do
  def range(from, to) when from <= to do
   do_range(from, to, [])
  end

  defp do_range(to, to, acc) do
    [to | acc]
  end

  defp do_range(from, to, acc) do
    do_range(from, to - 1, [to | acc])
  end

  def list_len(list) do
    do_list_len(0, list)
  end
  defp do_list_len(count, []) do
    count
  end
  defp do_list_len(count, [_| tail]) do
    do_list_len(count + 1, tail)
  end

  def positive(list) do
    do_positive(list, [])
  end
  defp do_positive([], acc) do
    acc
  end
  defp do_positive([h | t], acc) when h > 0 do
    do_positive(t, List.insert_at(acc, -1, h))
  end
  defp do_positive([ _ | t], acc) do
    do_positive(t, acc)
  end


end

defmodule Streams do
  def lines_length!(path) do
    File.stream!(path)
    |> Enum.map(&String.length/1)
  end

  defp longer_line(a, b) do
    cond do
      String.length(a) > String.length(b) -> a
      true -> b
    end
  end

  def longest_line!(path) do
    File.stream!(path)
    |> Enum.reduce("", &longer_line(&1, &2))
  end

  def longest_line_length!(path), do: longest_line!(path) |> String.length
end
