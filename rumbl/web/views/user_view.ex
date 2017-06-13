defmodule Rumbl.UserView do
  use Rumbl.Web, :view
  alias Rumbl.User

  def first_name(%User{username: name}) do
    name
    |> String.split(" ", trim: true)
    |> Enum.at(0)
  end
end
