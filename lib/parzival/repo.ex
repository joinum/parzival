defmodule Parzival.Repo do
  use Ecto.Repo,
    otp_app: :parzival,
    adapter: Ecto.Adapters.Postgres
end
