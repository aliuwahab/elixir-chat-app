defmodule Chat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :chat_id, :integer
      add :user_id, :integer
      add :message, :string

      timestamps()
    end
  end
end
