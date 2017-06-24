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
  end

  defp spawn_query(backend, query, limit) do 
    query_ref = make_ref()
    opts = [backend, query, query_ref, self(), limit]
    {:ok, pid} = Supervisor.start_child(Rumbl.InfoSys.Supervisor, opts)
    {pid, query_ref}
  end
end
