defmodule Parzival.Repo.Seeds.QRCodes do
  alias Parzival.Repo

  alias Parzival.Accounts.QRCode

  import Ecto

  def run do
    seed_qrs(100)
  end

  def seed_qrs(n) do
    case Repo.all(QRCode) do
      [] ->
        for _i <- 1..n do
          %QRCode{}
          |>QRCode.changeset(%{uuid: Ecto.UUID.generate()})
          |> Repo.insert()
        end
      _ ->
        Mix.shell().error("Found qr codes, aborting seeding qr codes.")
    end
  end
end

Parzival.Repo.Seeds.QRCodes.run()
