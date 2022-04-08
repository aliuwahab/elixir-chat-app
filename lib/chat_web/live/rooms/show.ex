defmodule ChatWeb.RoomsLive.Show do
  # use Phoenix.LiveView

  use ChatWeb, :live_view

  alias Chat.Chats
  alias Chat.Users
  alias ChatWeb.Presence

  defp topic(chat_id), do: "room:#{chat_id}"

  def mount(%{"room_id" => room_id, "user_id" => user_id} = _params, _session, socket) do
    chat = Chats.get_chat(room_id)
    current_user = Users.get_user(user_id)

    Presence.track_presence(
      self(),
      topic(chat.id),
      current_user.id,
      default_user_presence_payload(current_user)
    )

    ChatWeb.Endpoint.subscribe(topic(chat.id))

    {:ok,
     assign(socket,
       chat: chat,
       message: Chats.change_message(),
       current_user: current_user,
       users: Presence.list_presences(topic(chat.id)),
       username_colors: username_colors(chat)
     )}

   end

  def handle_info(%{event: "presence_diff"}, socket = %{assigns: %{chat: chat}}) do
    {:noreply,
     assign(socket,
       users: Presence.list_presences(topic(chat.id))
     )}
  end

  def handle_info(%{event: "message", payload: state}, socket) do
    IO.inspect("firsy")
    {:noreply, assign(socket, state)}
  end

  def handle_event("message", %{"message" => %{"message" => ""}}, socket) do
    {:noreply, socket}
  end

  def handle_event("message", %{"message" => message_params}, socket) do
    chat = Chats.create_message(message_params)
    ChatWeb.Endpoint.broadcast_from(self(), topic(chat.id), "message", %{chat: chat})
    {:noreply, assign(socket, chat: chat, message: Chats.change_message())}
  end

  def handle_event("typing", _value, socket = %{assigns: %{chat: chat, current_user: user}}) do
    # Presence.update_presence(self(), topic(chat.id), user.id, %{typing: true})
    {:noreply, socket}
  end

  def handle_event(
        "stop_typing",
        value,
        socket = %{assigns: %{chat: chat, current_user: user, message: message}}
      ) do
    # message = Chats.change_message(message, %{message: value})
    # Presence.update_presence(self(), topic(chat.id), user.id, %{typing: false})
    {:noreply, assign(socket, message: message)}
  end

  defp default_user_presence_payload(user) do
    %{
      typing: false,
      first_name: user.name,
      email: user.email,
      user_id: user.id
    }
  end

  defp random_color do
    hex_code =
      ColorStream.hex()
      |> Enum.take(1)
      |> List.first()

    "##{hex_code}"
  end


  def get_username_color(user, chat) do
    {_email, color} =
      Enum.find(username_colors(chat), fn {email, _color} ->
        email == user.email
      end)

    color
  end

  def username_colors(chat) do
    Enum.map(chat.messages, fn message -> message.user end)
    |> Enum.map(fn user -> user.email end)
    |> Enum.uniq()
    |> Enum.into(%{}, fn email -> {email, random_color()} end)
  end

  def font_weight(user, current_user) do
    if user.email == current_user.email do
      "bold"
    else
      "normal"
    end
  end

  def elipses(true), do: "..."
  def elipses(false), do: nil
end
