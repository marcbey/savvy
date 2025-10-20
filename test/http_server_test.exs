defmodule HttpServerTest do
  alias Savvy.HttpServer
  alias Savvy.HttpClient
  use ExUnit.Case

  import Savvy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    spawn(fn -> HttpServer.start(1024) end)

    urls = [
      "http://localhost:1024/wildthings",
      "http://localhost:1024/bears",
      "http://localhost:1024/bears/1",
      "http://localhost:1024/wildlife",
      "http://localhost:1024/api/bears"
    ]
    max_concurrent_requests = 5

    urls
    |> Enum.map(&Task.async(fn -> HTTPoison.get(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_successful_response/1)
  end

  defp assert_successful_response({:ok, response}) do
    assert response.status_code == 200
    # assert response.body == "Bears, Lions, Tigers"
  end
end
