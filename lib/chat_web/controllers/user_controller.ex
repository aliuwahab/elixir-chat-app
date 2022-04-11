defmodule ChatWeb.UserController do
  use ChatWeb, :controller

  alias Chat.Users
  alias Chat.Models.User

  def show(conn, %{"id" => user_id}) do
    user = Users.get_user(user_id)
    render(conn, "show.html", user: user)
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    changeset = Users.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"user" => user_params}) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "User created successfully.")
        # |> redirect(to: Routes.user_path(conn, :show, user))
        |> redirect(to: Routes.chat_path(conn, :index, user.id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
