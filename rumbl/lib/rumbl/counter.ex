
defmodule Rumbl.Counter do
  use GenServer

  ########
  # Client
  ########

  # GenServer.cast sends async message
  def inc(pid), do: GenServer.cast(pid, :inc)

  def dec(pid), do: GenServer.cast(pid, :dec)

  # GenServer.call sends synch message
  def val(pid) do
    GenServer.call(pid, :val)
  end

  ########
  # Server
  ########

  # Start a GenServer: spawns new proc and invokes init
  def start_link(initial_val) do
    GenServer.start_link(__MODULE__, initial_val)
  end

  def init(initial_val) do
    {:ok, initial_val}
  end

  # async functions. Note `:noreply`
  def handle_cast(:inc, val) do
    {:noreply, val + 1}
  end

  # async functions. Note `:noreply`
  def handle_cast(:dec, val) do
    {:noreply, val - 1}
  end

  # synchronous function
  def handle_call(:val, _from, val) do
    {:reply, val, val}
  end
end
