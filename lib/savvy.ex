defmodule Savvy do
  use Application

  def start(_type, _args) do
    IO.puts "Starting the application..."
    Savvy.Supervisor.start_link()
  end
end
