defmodule Parzival.Repo.Seeds do
  @moduledoc """
  Script for populating the database. You can run it as:
    $ mix run priv/repo/seeds.exs # or mix ecto.seed
  """
  @seeds_dir "priv/repo/seeds"

  def run do
    [
      "companies.exs",
      "accounts.exs",
      "offers.exs",
      "gamification.exs",
      "store.exs",
      "tools.exs",
      "applications.exs"
    ]
    |> Enum.each(fn file ->
      Code.require_file("#{@seeds_dir}/#{file}")
    end)
  end
end

Parzival.Repo.Seeds.run()
