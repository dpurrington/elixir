defmodule Todo.ProcessRegistry do
  import Kernel, except: [send: 2]

  def send(key, message) do
    case whereis_name(key) do
      :undefined -> {:badarg, {key, message}}
      pid ->
        Kernel.send(pid, message)
    end
  end

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def register_name(name, pid) do
    GenServer.call(__MODULE__, {:register_name, name, pid})
  end

  def whereis_name(name) do
    GenServer.call(__MODULE__, {:whereis_name, name})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:register_name, name, pid}, _, data) do
    case Map.get(data, name) do
      nil ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(data, name, pid)}
      _ ->
        {:reply, :no, data}
    end
  end

  def handle_call({:whereis_name, name}, _, data) do
    {:reply, Map.get(data, name), data}
  end

  def handle_info({:DOWN, _, :process, pid, _}, data) do
    {:noreply, deregister_pid(data, pid)}
  end

  defp deregister_pid(data, pid) do
    :maps.filter(fn(_, value) -> value != pid end, data)
  end
end
