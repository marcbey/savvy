defmodule HttpServerTest do
  alias Savvy.HttpServer
  alias Savvy.HttpClient
  use ExUnit.Case

  import Savvy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    parent = self()
    spawn(fn -> HttpServer.start(1024) end)

    url = "http://localhost:1024/wildthings"
    max_concurrent_requests = 5

    [1..max_concurrent_requests] |> Enum.each(fn _ ->
      spawn(fn ->
        {:ok, response} = HTTPoison.get(url)
        send(parent, {:ok, response})
      end)
    end)

    responses = [1..max_concurrent_requests] |> Enum.map(fn _ ->
      receive do
        {:ok, response} -> response
      end
    end)

    assert Enum.all?(responses, fn response -> response.status_code == 200 end)
    assert Enum.all?(responses, fn response -> response.body == "Bears, Lions, Tigers" end)
  end
end
