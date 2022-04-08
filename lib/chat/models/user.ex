defmodule Chat.Models.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

    @doc false
    def changeset(struct, params \\ %{}) do
      struct
      |> cast(params, [:name, :email, :password])
      |> validate_required([:name, :email])
      |> unique_constraint(:email, message: "Email has already been taken")
      |> generate_encrypted_password
    end

    defp generate_encrypted_password(changeset) do
      case changeset do
        %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
          put_change(changeset, :encrypted_password, Bcrypt.hash_pwd_salt(password))

        _ ->
          changeset
      end
    end
end
