defmodule Chat.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :room, :string

      timestamps()
    end
  end
end
