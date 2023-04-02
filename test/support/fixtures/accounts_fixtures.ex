defmodule Parzival.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Parzival.Accounts` context.
  """

  def unique_user_name, do: "user#{System.unique_integer()}"
  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    name = unique_user_name()

    Enum.into(attrs, %{
      name: name,
      email: "#{name}@example.com",
      password: valid_user_password(),
      role: :attendee
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Parzival.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
