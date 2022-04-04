defmodule Chat.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chats" do
    field :room, :string

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:room])
    |> validate_required([:room])
  end
end
