power_nap = fn ->
  time = :rand.uniform(10_000)
  :timer.sleep(time)
  {:slept, time}
end

parent = self()

spawn(fn -> send(parent, power_nap.()) end)

receive do
  {:slept, time} -> IO.inspect "Slept for #{time} milliseconds"
end
