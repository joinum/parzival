defmodule Parzival.Gamification do
  @moduledoc """
  The Gamification context.
  """

  import Ecto.Query, warn: false
  alias Parzival.Repo

  alias Parzival.Gamification.Curriculum

  @doc """
  Returns the list of curriculums.

  ## Examples

      iex> list_curriculums()
      [%Curriculum{}, ...]

  """
  def list_curriculums do
    Repo.all(Curriculum)
  end

  @doc """
  Gets a single curriculum.

  Raises `Ecto.NoResultsError` if the Curriculum does not exist.

  ## Examples

      iex> get_curriculum!(123)
      %Curriculum{}

      iex> get_curriculum!(456)
      ** (Ecto.NoResultsError)

  """
  def get_curriculum!(id), do: Repo.get!(Curriculum, id)

  @doc """
  Creates a curriculum.

  ## Examples

      iex> create_curriculum(%{field: value})
      {:ok, %Curriculum{}}

      iex> create_curriculum(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_curriculum(attrs \\ %{}) do
    %Curriculum{}
    |> Curriculum.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a curriculum.

  ## Examples

      iex> update_curriculum(curriculum, %{field: new_value})
      {:ok, %Curriculum{}}

      iex> update_curriculum(curriculum, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_curriculum(%Curriculum{} = curriculum, attrs) do
    curriculum
    |> Curriculum.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a curriculum.

  ## Examples

      iex> delete_curriculum(curriculum)
      {:ok, %Curriculum{}}

      iex> delete_curriculum(curriculum)
      {:error, %Ecto.Changeset{}}

  """
  def delete_curriculum(%Curriculum{} = curriculum) do
    Repo.delete(curriculum)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking curriculum changes.

  ## Examples

      iex> change_curriculum(curriculum)
      %Ecto.Changeset{data: %Curriculum{}}

  """
  def change_curriculum(%Curriculum{} = curriculum, attrs \\ %{}) do
    Curriculum.changeset(curriculum, attrs)
  end
end
