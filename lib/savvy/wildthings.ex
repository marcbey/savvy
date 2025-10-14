defmodule Savvy.Wildthings do
  alias Savvy.Bear

  def list_bears do
    Path.expand("../../db", __DIR__)
    |> Path.join("bears.json")
    |> read_json
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def get_bear(id) when is_integer(id) do
    Enum.find(list_bears(), fn(b) -> b.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer |> get_bear
  end

  def read_json(path) do
    case File.read(path) do
      {:ok, content} -> content
      {:error, reason} ->
        IO.inspect("File error: #{reason}")
        "[]"
    end
  end

end
