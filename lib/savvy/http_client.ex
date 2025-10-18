defmodule Savvy.HttpClient do
  @moduledoc """
  A module that provides a function to send a GET request to a given URL.

  Example usage:
  iex>
  """
  def get(port \\ 1024) do
    request = """
GET /bears HTTP/1.1\r
Host: example.com\r
User-Agent: ExampleBrowser/1.0\r
Accept: */*\r
\r
"""

    local_host = ~c"localhost"
    case :gen_tcp.connect(local_host, port, [:binary, packet: :raw, active: false]) do
      {:ok, sock} ->
        :ok = :gen_tcp.send(sock, request)
        :ok = :gen_tcp.close(sock)
      {:error, response} ->
        {:error, response}
    end
  end
end
