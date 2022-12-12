defmodule TodoEntry do
  defstruct id: nil, value: nil

  def new(id, value) do
    %TodoEntry{id: id, value: value}
  end
end

defmodule TodoList do
  defstruct auto_id: 1, entries: Map.new
  def new (entries \\ []) do
    Enum.reduce(
      entries,
      %TodoList{},
      &add_entry(&2, &1)
    )
  end

  def add_entry(%TodoList{entries: entries, auto_id: auto_id} = tdl, %{date: _, title: _ } = entry) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)
    %TodoList{ tdl | entries: new_entries, auto_id: auto_id + 1}
  end

  def entries(%TodoList{ entries: entries}, date) do
    Stream.filter(entries, fn({_, entry}) ->
      entry.date == date
    end)
    |> Stream.map(fn({_, entry}) ->
      entry
    end)
  end

  def update_entry(%TodoList{entries: entries} = tdl, id, updater) do
    case entries[id] do
      nil -> tdl

      old_entry ->
        old_entry_id = old_entry.id
        %TodoEntry{} = new_entry = %{id: ^old_entry_id} = updater.(old_entry)
        new_entries = Map.put(entries, id, new_entry)
        %TodoList{ tdl | entries: new_entries}
    end
  end

  def update_entry(%TodoList{} = tdl, %TodoEntry{id: id} = new_entry) do
    update_entry(tdl, id, fn(_) -> new_entry end)
  end

  def delete_entry(%TodoList{ entries: entries } = tdl, id) do
      new_entries = Map.filter(entries, fn(e) -> e.id != id end)
      put_in(tdl.entries, new_entries)
  end
end

defmodule TodoList.CsvImporter do
  def import(path) do
    File.stream!(path)
    |> Stream.map(fn(line) ->
        [ date, text] = String.split(line, ",")
        text = String.replace(text, "\n", "")
        [year, month, day] = String.split(date, "/")
          |> Enum.map(&String.to_integer(&1))
        %{ date: {year, month, day}, title: text}
    end)
    |> Enum.to_list
    |> TodoList.new
  end
end
