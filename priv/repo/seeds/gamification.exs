defmodule Parzival.Repo.Seeds.Curriculums do
  import Ecto.Query

  alias Parzival.Repo
  alias Parzival.Accounts.User
  alias Parzival.Gamification.Curriculum

  # @companies File.read!("priv/repo/seeds/data/companies.txt") |> String.split("\n")
  # @job_titles File.read!("priv/repo/seeds/data/job_titles.txt") |> String.split("\n")

  def run do
    seed_curriculums()
  end

  def seed_curriculums do
    case Repo.all(Curriculum) do
      [] ->
        attendees =
          User
          |> where(role: :attendee)
          |> Repo.all()

        for attendee <- attendees do
          Curriculum.changeset(%Curriculum{}, %{
            summary: Faker.Lorem.sentence(20..40),
            user_id: attendee.id,
            experience:
              Enum.reduce(
                List.duplicate(:experience, Enum.random(1..3)),
                [],
                fn _n, acc ->
                  [
                    %{
                      company_name: Faker.Company.name(),
                      job:
                        Enum.reduce(
                          List.duplicate(:job, Enum.random(1..4)),
                          [],
                          fn _next, acc ->
                            [
                              %{
                                job_title: Faker.Person.title(),
                                start_date:
                                  Faker.DateTime.between(~D[2018-04-11], ~D[2021-04-11]),
                                end_date:
                                  Faker.DateTime.between(
                                    ~D[2021-04-11],
                                    Date.utc_today()
                                  ),
                                present: Enum.random([true, false, false, false])
                              }
                              | acc
                            ]
                          end
                        )
                    }
                    | acc
                  ]
                end
              )
          })
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found Curriculums, aborting seeding curriculums.")
    end
  end

  # defp insert_curriculum(data) do
  #   %Curriculum{}
  #   |> Curriculum.changeset(data)
  #   |> Repo.insert!()
  # end
end

Parzival.Repo.Seeds.Curriculums.run()
