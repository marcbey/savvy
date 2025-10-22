defmodule PledgeServerTest do
  use ExUnit.Case, async: true

  test "starts and registers the server" do
    {:ok, server} = start_supervised(Savvy.PledgeServer)

    assert is_pid(server)
    assert Process.alive?(server)
  end

  test "create pledge is working" do
    {:ok, _server} = start_supervised(Savvy.PledgeServer)

    Savvy.PledgeServer.create_pledge("foo", 10)
    Savvy.PledgeServer.create_pledge("bar", 20)
    pledges = Savvy.PledgeServer.recent_pledges()

    assert pledges == [{"bar", 20}, {"foo", 10}]
  end

  test "total pledged is working" do
    {:ok, _server} = start_supervised(Savvy.PledgeServer)

    Savvy.PledgeServer.create_pledge("foo", 10)
    Savvy.PledgeServer.create_pledge("bar", 20)
    total = Savvy.PledgeServer.total_pledged()

    assert total == 30
  end
end
