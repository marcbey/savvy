defmodule Savvy.Api.BearController do

  def index(conv) do
    json =
      Savvy.Wildthings.list_bears()
      |> Poison.encode!

    %{ conv | status: 200, resp_headers: %{"Content-Type" => "application/json"}, resp_body: json }
  end

end
