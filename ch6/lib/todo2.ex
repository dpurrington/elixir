defmodule TodoEntry do
  defstruct id: nil, value: nil

  @spec new(any, any) :: %TodoEntry{id: any, value: any}
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

defmodule TodoServer do
  def start do
    Process.register(ServerProcess.start(TodoServer), :todo_server)
  end

  def init do
    TodoList.new
  end

  def add_entry(entry) do
    ServerProcess.cast(:todo_server, {:add_entry, entry})
  end

  def entries(date) do
    ServerProcess.call(:todo_server, {:entries, date, self()})
  end

  def handle_cast({:add_entry, entry}, tdl) do
      TodoList.add_entry(tdl, entry)
  end

  def handle_call(tdl, {:entries, date}) do
      TodoList.entries(tdl, date)
  end
end

defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init
      loop(callback_module, initial_state)
    end)
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} = callback_module.handle_call(request, current_state)
        send(caller, {:response, response})
        loop(callback_module, new_state)
      {:cast, request} ->
        new_state = callback_module.handle_cast(request, current_state)
        loop(callback_module, new_state)
    end
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})
    receive do
      {:response, response} -> response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request, self()})
  end
end
