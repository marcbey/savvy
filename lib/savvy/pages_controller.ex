defmodule Savvy.BearController do

  alias Savvy.Wildthings
  alias Savvy.Bear

  @templates_path Path.expand("../../pages", __DIR__)

  def faq(conv) do
    bears =
      Wildthings.list_bears()
      |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "faq.md", bindings)
  end

  defp render(conv, template, bindings) do
    content =
      @templates_path
      |> Path.join(template)
      |> EEx.eval_file(bindings)

    %{ conv | status: 200, resp_body: content }
  end

end
