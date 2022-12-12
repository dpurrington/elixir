defmodule HelloNerves.Http do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get("/", do: send_resp(conn, 200, "Feel free to use API endpoints!"))

  get "/enable" do
    HelloNerves.Blinker.enable()
    send_resp(conn, 200, "LED enabled")
  end

  get "/disable" do
    HelloNerves.Blinker.disable()
    send_resp(conn, 200, "LED disabled")
  end

  match(_, do: send_resp(conn, 404, "Oops!"))
end
