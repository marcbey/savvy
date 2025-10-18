defmodule HttpServerTest do
  alias Savvy.HttpServer
  alias Savvy.HttpClient
  use ExUnit.Case

  import Savvy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    spawn(fn -> HttpServer.start(1024) end)
    response = HttpClient.get(request, 1024)

    assert response == {:ok, """
           HTTP/1.1 200 OK\r
           Content-Type: text/html\r
           Content-Length: 20\r
           \r
           Bears, Lions, Tigers
           """}
  end
end
