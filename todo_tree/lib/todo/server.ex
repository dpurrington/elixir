
defmodule Todo.Server do
  use GenServer
  def start(name) do
    IO.puts("starting server for #{name}")
    GenServer.start_link(Todo.Server, name)
  end

  def init(name) do
    IO.puts("initting server")
    {:ok, {name, Todo.Database.get(name) || Todo.List.new}}
  end

  defp store_no_reply(name, new_list) do
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  def handle_cast({:add, entry}, {name, todo_list}) do
    store_no_reply(name, Todo.List.add_entry(todo_list, entry))
  end

  def handle_cast({:update, entry}, {name, todo_list}) do
    store_no_reply(name, Todo.List.update_entry(todo_list, entry))
  end

  def handle_cast({:delete, entry_id}, {name, todo_list}) do
    store_no_reply(name, Todo.List.delete_entry(todo_list, entry_id))
  end

  def handle_call({:entries, date}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, date), {name, todo_list}}
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add, entry})
  end
  def update_entry(pid, entry) do
    GenServer.cast(pid, {:update, entry})
  end
  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:delete, entry_id})
  end
  def entries(pid, date) do
    GenServer.call(pid, {:entries, date})
  end
end
