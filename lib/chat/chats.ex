defmodule Chat.Chats do

  alias Chat.Repo
  alias Chat.Models.Message
  alias Chat.Models.Chat
  import Ecto.Query

  def create_chat(chat_params) do
    Chat.changeset(%Chat{}, chat_params)
    |> Repo.insert()
  end

  def create_message(message_params) do
    Message.changeset(%Message{}, message_params)
    |> Repo.insert!()

    get_chat(message_params["chat_id"])
  end

  def change_message do
    Message.changeset(%Message{})
  end

  def change_message(changeset, changes) do
    Message.changeset(changeset, changes)
  end

  def list_chats do
    Repo.all(Chat)
  end

  def get_chat(chat_id) do
    query =
      from c in Chat,
        where: c.id == ^chat_id,
        preload: [messages: :user]

    Repo.one(query)
  end
end
