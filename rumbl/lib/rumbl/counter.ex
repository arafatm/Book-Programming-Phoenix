defmodule Rumbl.Counter do

  # Client Code

  def inc(pid), do: send(pid, :inc) # async send :inc to server proc

  def dec(pid), do: send(pid, :dec)

  def val(pid, timeout \\ 5000) do
    ref = make_ref()
    send(pid, {:val, self(), ref})
    receive do                      # wait for response from server
      {^ref, val} -> val    # only match tuple with exact ^ref
    after timeout -> exit(:timeout) # exit if no resp w/in timeout
    end
  end

  # Server Code


  # OTP requires start_link
  def start_link(initial_val) do 
    {:ok, spawn_link(fn -> listen(initial_val) end)} # spawn a proc and return {:ok, pid}
  end

  defp listen(val) do
    receive do
      # listen for def inc(pid) or dec(pid) from above
      :inc -> listen(val + 1) 
      :dec -> listen(val - 1)

      {:val, sender, ref} ->
        IO.puts ":val"
        IO.puts "- sender:  #{inspect sender}"
        IO.puts "- ref:  #{inspect ref}"
        send sender, {ref, val}
        listen(val) # use recursion to keep server alive
    end
  end
end
