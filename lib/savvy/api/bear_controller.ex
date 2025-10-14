defmodule Savvy.Api.BearController do
  def index(conv) do
    json =
      Savvy.Wildthings.list_bears()
      |> Poison.encode!

    %{ conv | status: 200, resp_headers: %{"Content-Type" => "application/json"}, resp_body: json }
  end

  def create(conv, %{"name" => name, "type" => type}) do
    body = "Created a #{type} bear named #{name}!"
    %{ conv | status: 201, resp_headers: %{"Content-Type" => "application/json"}, resp_body: body }
  end
end
