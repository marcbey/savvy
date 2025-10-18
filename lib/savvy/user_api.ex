defmodule Savvy.UserApi do
  def query(id) do
    id
    |> api_url
    |> get
    |> parse_response
  end

  def api_url(id) do
    "https://jsonplaceholder.typicode.com/users/#{URI.encode(id)}"
  end

  defp get(url) do
    HTTPoison.get(url)
  end

  defp parse_response(%HTTPoison.Response{status_code: 200, body: body}) do
    city =
      Poison.Parser.parse!(body, %{}) |>
      get_in(["address", "city"])

      {:ok, city}
  end

  defp parse_response(%HTTPoison.Response{status_code: _status_code, body: body}) do
    message =
      Poison.Parser.parse!(body, %{}) |>
      get_in(["message"])

    {:error, message}
  end

  defp parse_response(%HTTPoison.Error{reason: reason}) do
    {:error, reason}
  end
end
