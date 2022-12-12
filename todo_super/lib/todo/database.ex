defmodule Todo.Database do
  use GenServer
  @db_folder "./persist/"

  def start() do
    IO.puts("starting database")
    GenServer.start_link(__MODULE__, nil, name: :database_server)
  end

  def store(key, value) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, value)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    GenServer.call(:database_server, {:choose_worker, key})
  end

  def init(_) do
    File.mkdir_p(@db_folder)
    {:ok, create_workers()}
  end

  def handle_call({:choose_worker, key}, _, workers) do
    worker_key = :erlang.phash2(key, 2)

    {:reply, Map.get(workers, worker_key), workers}
  end

  defp create_workers() do
    for i <- 0..2, into: %{} do
      {:ok, pid} = Todo.DatabaseWorker.start(@db_folder)
      {i, pid}
    end
  end
end
