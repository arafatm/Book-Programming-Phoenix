defmodule Rumbl.InfoSys do

  # list supported backends
  @backends [Rumbl.InfoSys.Wolfram]

  # response struct expected
  defmodule Result do
    defstruct score: 0, text: nil, url: nil, backend: nil
  end

  # call start_link for selected backend
  def start_link(backend, query, query_ref, owner, limit) do 
    backend.start_link(query, query_ref, owner, limit)
  end

  # map over all backends calling spawn_query
  # spawn_query starts a child with opts incl. unique ref. 
  # returns child pid and unique ref
  def compute(query, opts \\ []) do 
    limit = opts[:limit] || 10
    backends = opts[:backends] || @backends

    backends
    |> Enum.map(&spawn_query(&1, query, limit))
    |> await_results(opts)                # Wait for results
    |> Enum.sort(&(&1.score >= &2.score)) # sort by score
    |> Enum.take(limit)                   # only report top results
  end

  defp spawn_query(backend, query, limit) do 
    query_ref = make_ref()
    opts = [backend, query, query_ref, self(), limit]
    {:ok, pid} = Supervisor.start_child(Rumbl.InfoSys.Supervisor, opts)
    monitor_ref = Process.monitor(pid)      # monitor the child process
    {pid, monitor_ref, query_ref}
  end

  defp await_results(children, _opts) do
    await_result(children, [], :infinity)
  end

  # Accumulate results
  defp await_result([head|tail], acc, timeout) do
    {pid, monitor_ref, query_ref} = head

    receive do
      {:results, ^query_ref, results} -> 
        # :flush removes :DOWN message in case it's delivered before we drop the monitor
        Process.demonitor(monitor_ref, [:flush])
        await_result(tail, results ++ acc, timeout)
      {:DOWN, ^monitor_ref, :process, ^pid, _reason} -> 
        await_result(tail, acc, timeout)
    end
  end

  # Return accumulated results from previous await_results
  defp await_result([], acc, _) do 
    acc
  end
end
