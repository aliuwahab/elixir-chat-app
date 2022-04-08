defmodule Chat.Models.Message do
  use Ecto.Schema

  alias Chat.Models.User
  import Ecto.Changeset

  schema "messages" do
    field :chat_id, :integer
    field :message, :string
    # field :user_id, :integer

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(message, params \\ %{}) do
    message
    |> cast(params, [:chat_id, :user_id, :message])
    |> validate_required([:chat_id, :user_id, :message])
  end
end
