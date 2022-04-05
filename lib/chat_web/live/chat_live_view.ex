defmodule ChatWeb.ChatLiveView do
  use Phoenix.LiveView
  alias Phat.Chats

  def render(assigns) do
    PhatWeb.ChatView.render("show.html", assigns)
  end

  def mount(%{chat: chat, current_user: current_user}, socket) do
    ChatWeb.Endpoint.subscribe(topic(chat.id))

    {:ok,
     assign(socket,
       chat: chat,
       message: Chats.change_message(),
       current_user: current_user
     )}
  end

  def handle_info(%{event: "message", payload: state}, socket) do
    {:noreply, assign(socket, state)}
  end

  def handle_event("message", %{"message" => message_params}, socket) do
    chat = Chats.create_message(message_params)
    ChatWeb.Endpoint.broadcast_from(topic(chat.id), self(), "message", %{chat: chat})
    {:noreply, assign(socket, chat: chat, message: Chats.change_message())}
  end

  defp topic(chat_id), do: "chat:#{chat_id}"
end
