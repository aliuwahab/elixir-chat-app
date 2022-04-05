defmodule ChatWeb.ChatController do
  use ChatWeb, :controller
  alias Repos.Chats
  alias Phoenix.LiveView
  alias ChatWeb.ChatLiveView

  def index(conn, _params) do
    chats = Chats.list_chats()
    render(conn, "index.html", chats: chats)
  end

  def show(conn, %{"id" => chat_id}) do
    chat = Chats.get_chat(chat_id)

    LiveView.Controller.live_render(
      conn,
      ChatLiveView,
      session: %{chat: chat, current_user: conn.assigns.current_user}
    )
  end
end
