
defmodule Todo.Server do
  use GenServer
  def start(entries \\ []) do
    GenServer.start(Todo.Server, entries)
  end

  def init(entries) do
    {:ok, Todo.List.new(entries)}
  end

  def handle_cast({:add, entry}, state) do
    {:noreply, Todo.List.add_entry(state, entry)}
  end

  def handle_cast({:update, entry}, state) do
    {:noreply, Todo.List.update_entry(state, entry)}
  end

  def handle_cast({:delete, entry_id}, state) do
    {:noreply, Todo.List.delete_entry(state, entry_id)}
  end

  def handle_call({:entries, date}, _, state) do
    {:reply, Todo.List.entries(state, date), state}
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
