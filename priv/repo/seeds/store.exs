defmodule Parzival.Repo.Seeds.Store do
  alias Parzival.Repo

  alias Parzival.Store.Product

  def run do
    seed_products()
  end

  def seed_products do
    case Repo.all(Product) do
      [] ->
        [
          %{
            name: "Saco",
            description: "É um saco",
            price: 20,
            stock: 100,
            max_per_user: 50
          },
          %{
            name: "Caderno",
            description: "É um caderno",
            price: 200,
            stock: 5,
            max_per_user: 2
          },
          %{
            name: "Caneta",
            description: "É uma caneta",
            price: 200,
            stock: 5,
            max_per_user: 2
          }
        ]
        |> Enum.each(&insert_product/1)

      _ ->
        Mix.shell().error("Found products, aborting seeding products.")
    end
  end

  defp insert_product(data) do
    %Product{}
    |> Product.changeset(data)
    |> Repo.insert!()
  end
end

Parzival.Repo.Seeds.Store.run()
