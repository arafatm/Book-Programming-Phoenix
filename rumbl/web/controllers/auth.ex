defmodule Rumbl.Auth do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo) # raise exception if key :repo doesn't exist
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user    = user_id && repo.get(Rumbl.User, user_id) # lookup user if user_id exists
    assign(conn, :current_user, user)
  end
end
