defmodule Chat.Models.Chat do
  use Ecto.Schema

  alias Chat.Models.Message
  import Ecto.Changeset

  schema "chats" do
    field :room, :string
    has_many :messages, Message

    timestamps()
  end

  @doc false
  def changeset(chat, params \\ %{}) do
    chat
    |> cast(params, [:room])
    |> validate_required([:room])
  end
end
