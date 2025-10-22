defmodule PledgeServerTest do
  use ExUnit.Case, async: true

  # setup do
  #   # Kill any existing pledge server process
  #   case Process.whereis(:pledge_server) do
  #     nil -> :ok
  #     pid -> Process.exit(pid, :kill)
  #   end

  #   # Wait a moment for the process to be cleaned up
  #   Process.sleep(10)

  #   :ok
  # end

  test "start is spawning and registering" do
    {:ok, server} = start_supervised(Savvy.PledgeServer)
    # server = Savvy.PledgeServer.start

    assert is_pid(server)
    assert Process.whereis(:pledge_server)
  end

  test "create pladge is working" do
    {:ok, _server} = start_supervised(Savvy.PledgeServer)

    Savvy.PledgeServer.create_pledge("foo", 10)
    Savvy.PledgeServer.create_pledge("bar", 20)
    pledges = Savvy.PledgeServer.recent_pledges

    assert pledges == [{"bar", 20}, {"foo", 10}]
  end

  test "total pledged is working" do
    {:ok, _server} = start_supervised(Savvy.PledgeServer)

    Savvy.PledgeServer.create_pledge("foo", 10)
    Savvy.PledgeServer.create_pledge("bar", 20)
    total = Savvy.PledgeServer.total_pledged

    assert total == 30
  end
end
