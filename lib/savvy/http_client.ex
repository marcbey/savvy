defmodule Savvy.HttpClient do
  @moduledoc """
  A module that provides a function to send HTTP requests to a local server.

  This client connects to a local HTTP server running on the specified port
  and sends raw HTTP request strings, returning the raw HTTP response.

  ## Examples

      iex> Savvy.HttpClient.get("GET /bears HTTP/1.1\\r\\nHost: localhost\\r\\n\\r\\n", 1024)
      {:ok, "HTTP/1.1 200 OK\\r\\nContent-Type: text/html\\r\\nContent-Length: 356\\r\\n\\r\\n<h1>All The Bears!</h1>\\n\\n<ul>\\n  \\n    <li>Brutus - Grizzly</li>\\n  \\n    <li>Iceman - Polar</li>\\n  \\n    <li>Kenai - Grizzly</li>\\n  \\n    <li>Paddington - Brown</li>\\n  \\n    <li>Roscoe - Panda</li>\\n  \\n    <li>Rosie - Black</li>\\n  \\n    <li>Scarface - Grizzly</li>\\n  \\n    <li>Smokey - Black</li>\\n  \\n    <li>Snow - Polar</li>\\n  \\n    <li>Teddy - Brown</li>\\n  \\n</ul>\\n\\n"}

      iex> Savvy.HttpClient.get("invalid request", 9999)
      {:error, :econnrefused}
  """

  @default_port 1024
  @default_host ~c"localhost"
  @connection_options [:binary, packet: :raw, active: false]

  @doc """
  Sends an HTTP request to the local server and returns the response.

  ## Parameters

    * `request` - Raw HTTP request string (default: empty string)
    * `port` - Port number to connect to (default: #{@default_port})

  ## Returns

    * `{:ok, response}` - Success with the raw HTTP response
    * `{:error, reason}` - Error with the reason (e.g., `:econnrefused`, `:timeout`)

  ## Examples

      iex> Savvy.HttpClient.get("GET /bears HTTP/1.1\\r\\nHost: localhost\\r\\n\\r\\n")
      {:ok, "HTTP/1.1 200 OK\\r\\nContent-Type: text/html\\r\\nContent-Length: 356\\r\\n\\r\\n<h1>All The Bears!</h1>\\n\\n<ul>\\n  \\n    <li>Brutus - Grizzly</li>\\n  \\n    <li>Iceman - Polar</li>\\n  \\n    <li>Kenai - Grizzly</li>\\n  \\n    <li>Paddington - Brown</li>\\n  \\n    <li>Roscoe - Panda</li>\\n  \\n    <li>Rosie - Black</li>\\n  \\n    <li>Scarface - Grizzly</li>\\n  \\n    <li>Smokey - Black</li>\\n  \\n    <li>Snow - Polar</li>\\n  \\n    <li>Teddy - Brown</li>\\n  \\n</ul>\\n\\n"}

      iex> Savvy.HttpClient.get("GET /bears HTTP/1.1\\r\\nHost: localhost\\r\\n\\r\\n", 8080)
      {:error, :econnrefused}
  """
  @spec get(binary(), pos_integer()) :: {:ok, binary()} | {:error, atom()}
  def get(request \\ "", port \\ @default_port) when is_binary(request) and is_integer(port) do
    case connect_to_server(port) do
      {:ok, socket} ->
        with :ok <- send_request(socket, request),
             {:ok, response} <- receive_response(socket) do
          close_socket(socket)
          {:ok, response}
        else
          error ->
            close_socket(socket)
            error
        end
      {:error, _reason} = error ->
        error
    end
  end

  # Private helper functions

  @spec connect_to_server(pos_integer()) :: {:ok, :gen_tcp.socket()} | {:error, atom()}
  defp connect_to_server(port) do
    :gen_tcp.connect(@default_host, port, @connection_options)
  end

  @spec send_request(:gen_tcp.socket(), binary()) :: :ok | {:error, atom()}
  defp send_request(socket, request) do
    :gen_tcp.send(socket, request)
  end

  @spec receive_response(:gen_tcp.socket()) :: {:ok, binary()} | {:error, atom()}
  defp receive_response(socket) do
    :gen_tcp.recv(socket, 0)
  end

  @spec close_socket(:gen_tcp.socket() | nil) :: :ok
  defp close_socket(nil), do: :ok
  defp close_socket(socket) do
    :gen_tcp.close(socket)
  end
end
