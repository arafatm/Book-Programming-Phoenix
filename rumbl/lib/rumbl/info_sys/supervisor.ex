defmodule Rumbl.InfoSys.Supervisor do
  use Supervisor

  # start Supervisor 
  def start_link() do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  # initialize workers
  def init(_opts) do
    children = [
      worker(Rumbl.InfoSys, [], restart: :temporary)
    ]

    # start Supervisor 
    supervise children, strategy: :simple_one_for_one
  end
end
