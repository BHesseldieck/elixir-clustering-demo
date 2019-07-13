defmodule QuackingDuck do
  def start do
    spawn(fn -> loop(0) end)
  end

  def loop(uptime) do
    receive do
      :stop ->
        IO.puts("Quacking duck over and out!")
        exit(:normal)
      after 2000 ->
        IO.puts("Quacking the #{uptime}. time on #{node()}")
      end
      QuackingDuck.loop(uptime + 1)
  end
end