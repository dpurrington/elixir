defmodule TodoList do
  def new, do: HashDict.new

  def add_entry(todo_list, date, title) do
    HashDict.update(
      todo_list,
      date,
      [title],
      fn(titles) -> [title | titles] end
    )
  end

  def entries(todo_list, date) do

  end
end
