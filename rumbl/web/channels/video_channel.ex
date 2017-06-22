defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel
  require Logger

  def join("videos:" <> _video_id, _params, socket) do
    IO.puts "VideoChannel join"
    {:ok, socket}
  end

  def handle_in("new_annotation", params, socket) do
    IO.puts "handle_info new_annotation"
    broadcast! socket, "new_annotation", %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    }

    {:reply, :ok, socket}
  end
end
