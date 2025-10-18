defmodule Savvy.Timer do
  @moduledoc """
  a Timer module that has a remind function taking two arguments:
  a string representing something you want to be reminded about
  and the number of seconds in the future when you want to be reminded
  about that thing

  example usage:

    iex> Timer.remind("Stand Up", 5)
    Stand Up now!

    iex> Timer.remind("Sit Down", 10)
    Sit Down now!

    iex> Timer.remind("Fight, Fight, Fight", 15)
    Fight, Fight, Fight now!
  """

  def remind(message \\ "Do", seconds \\ 1) do
    spawn_link(fn ->
      :timer.sleep(seconds * 1000)
      IO.puts("#{message} now!")
    end)
  end
end
