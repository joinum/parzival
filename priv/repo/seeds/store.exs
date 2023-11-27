defmodule Parzival.Repo.Seeds.Store do
  alias Parzival.Repo

  alias Parzival.Store.Boost
  alias Parzival.Store.Product

  def run do
    seed_products()
    seed_boosts()
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

  def seed_boosts do
    case Repo.all(Boost) do
      [] ->
        [
          %{
            name: "2x EXP",
            description: "Este boost, quando ativado, duplica a EXP ganha durante 1 hora.",
            price: 200,
            type: :exp,
            multiplier: 2.0
          },
          %{
            name: "1.5x EXP",
            description: "Este boost, quando ativado, aumenta em 50% a EXP ganha durante 1 hora.",
            price: 150,
            type: :exp,
            multiplier: 1.5
          },
          %{
            name: "1.25x EXP",
            description: "Este boost, quando ativado, aumenta em 25% a EXP ganha durante 1 hora.",
            price: 125,
            type: :exp,
            multiplier: 1.25
          },
          %{
            name: "2x 💰",
            description: "Este boost, quando ativado, duplica os 💰 ganhos durante 1 hora.",
            price: 200,
            type: :exp,
            multiplier: 2.0
          },
          %{
            name: "1.5x 💰",
            description: "Este boost, quando ativado, aumenta em 50% os 💰 ganhos durante 1 hora.",
            price: 150,
            type: :exp,
            multiplier: 1.5
          },
          %{
            name: "1.25x 💰",
            description: "Este boost, quando ativado, aumenta em 25% os 💰 ganhos durante 1 hora.",
            price: 125,
            type: :exp,
            multiplier: 2.0
          },
          %{
            name: "Skip Task",
            description:
              "Este boost, quando ativado, permite saltar uma task, completando a automaticamente.",
            price: 200,
            type: :skip_task
          }
        ]
        |> Enum.each(&insert_boost/1)

      _ ->
        Mix.shell().error("Found boosts, aborting seeding boosts.")
    end
  end

  defp insert_boost(data) do
    %Boost{}
    |> Boost.changeset(data)
    |> Repo.insert!()
  end
end

Parzival.Repo.Seeds.Store.run()
