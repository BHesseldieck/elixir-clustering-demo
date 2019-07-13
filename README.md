# elixir-clustering-demo
Demo of how clustering with elixir works

# Setup
Create 3+ panes in your terminal, each will host an `iex` (interactive elixir) shell that executes a BEAM-VM (a cluster node).

Start each `iex` with: `iex --sname #{node_name} --cookie duck`

With `Node.list` you can see that each VM runs isolated for now.

Now we want to start connecting the VMs. Use the command `Node.connect(:#{node_name}@#{your machine name})` to connect the VMs. The function returns `true` if it has successfully set a connection. You can use `Node.list` again to check which nodes (VMs) are connected.

Next step is to compile our elixir file with `c("quacking_duck.ex", "./")`

# Running distributed on the cluster

Now, since we compiled the file, we can run the program.

Use `pid = QuackingDuck.start` to start a process.

Now try the command in a different pane (different VM). You will see an `UndefinedFunctionError`. This error occurrs because just the VM where we compiled the code knows about it. However, elixir has neat tooling to fix this easily.

Spread your code to all connected nodes with running `nl QuackingDuck` on the node, where the program was compiled, and try `pid = QuackingDuck.start` again on the other node and it starts running the code.

Next step is to launch the process remotely from our main node on a different one. Use `pid2 = Node.spawn :#{node_name}@#{your machine name}, QuackingDuck, :start, []`. We see that it starts the process on the other node, but pipes the output back to the initiator. As evidence: killing the remote machine stops the process execution.

# Hot code reloading on the cluster

Do some changes in the output String (`IO.puts("#{changes in here}")`), then execute `c("quacking_duck.ex", "./")` and you will see that the changes are hot reloaded into your running process (You should see different output).

Now we want to spread the changes to the cluster. We again use `nl QuackingDuck` on the same node to do that. You will see that now all of the cluster's nodes print the updated output.

