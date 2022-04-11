defmodule ChatWeb.ChatController do
  use ChatWeb, :controller
  alias Chat.Chats
  alias Phoenix.LiveView
  alias Chat.Users

  plug :authenticate_user

  def index(conn, %{"user_id" => user_id}) do
    chats = Chats.list_chats()
    render(conn, "index.html", chats: chats, user_id: user_id)
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/sessions/new")
        |> halt()

      user_id ->
        assign(conn, :current_user, Users.get_user(user_id))
    end
  end
end
