defimpl String.Chars, for: Todo.List do
  def to_string(_) do
    "#Todo.List"
  end
end
defimpl Collectable, for: Todo.List do
  def into(original) do
    {original, &into_callback/2}
  end
  defp into_callback(list, {:cont, entry}) do
    Todo.List.add_entry(list, entry)
  end
  defp into_callback(list, :done), do: list
  defp into_callback(_, :halt), do: :ok
end

defmodule Todo.List do
  defstruct auto_id: 1, entries: Map.new
  def new(entries \\[]) do
    Enum.reduce(
      entries,
      %Todo.List{},
      &add_entry(&2, &1)
    )
  end

  def add_entry(%Todo.List{auto_id: auto_id, entries: entries}, entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)
    %Todo.List{entries: new_entries, auto_id: auto_id + 1}
  end

  def entries(%Todo.List{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_, e}) -> e.date == date end)
    |> Enum.map(fn({_,e}) -> e end)
  end

  def update_entry(%Todo.List{} = list, %{} = entry) do
    update_entry(list, entry.id, fn(_) -> entry end)
  end

  def update_entry(%Todo.List{entries: entries}, entry_id, updater_fun) do
    #what
    put_in(entries[entry_id], updater_fun.())
  end

  def delete_entry(%Todo.List{entries: entries} = list, entry_id) do
    %Todo.List{list | entries: Enum.filter(entries, &(&1 != entry_id))}
  end

  def update_entry_old(%Todo.List{entries: entries} = list, entry_id, updater_fun) do
    case entries[entry_id] do
      nil -> list
      old_entry ->
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %Todo.List{list | entries: new_entries}
    end
  end
end

defmodule Todo.List.CsvImporter do
  def import!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.split(&1, ","))
    |> Stream.map(fn([datestr, title]) ->
          [year, month, day] = for piece <- String.split(datestr, "/") do
            String.to_integer(piece)
          end
          %{date: {year, month, day}, title: title}
        end
    )
    |> Todo.List.new
  end
end
