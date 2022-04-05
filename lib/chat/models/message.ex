defmodule Chat.Models.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :chat_id, :integer
    field :message, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:chat_id, :user_id, :message])
    |> validate_required([:chat_id, :user_id, :message])
  end
end
