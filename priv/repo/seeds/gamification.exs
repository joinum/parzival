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
          n_experience = List.duplicate(:experience, Enum.random(1..4))
          n_jobs = List.duplicate(:job, Enum.random(1..5))

          Curriculum.changeset(%Curriculum{}, %{
            summary: Faker.Lorem.sentence(20..40),
            user_id: attendee.id,
            experience:
              Enum.reduce(n_experience, [], fn _n, acc ->
                [
                  %{
                    company_name: Faker.Company.name(),
                    job:
                      Enum.reduce(n_jobs, [], fn _next, acc ->
                        [
                          %{
                            job_title: Faker.Person.title(),
                            start_date: Faker.DateTime.backward(1825),
                            end_date: Faker.DateTime.backward(365),
                            present: Enum.random([true, false])
                          }
                          | acc
                        ]
                      end)
                  }
                  | acc
                ]
              end)
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
