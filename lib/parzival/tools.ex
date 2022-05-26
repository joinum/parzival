defmodule Parzival.Tools do
  @moduledoc """
  The Tools context.
  """
  use Parzival.Context

  import Ecto.Query, warn: false

  alias Parzival.Repo
  alias Parzival.Tools.Faq

  @doc """
  Returns the list of faqs.

  ## Examples

      iex> list_faqs()
      [%Faqs{}, ...]

  """
  def list_faqs(params \\ %{})

  def list_faqs(opts) when is_list(opts) do
    Faq
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_faqs(flop) do
    Flop.validate_and_run(Faq, flop, for: Faq)
  end

  def list_faqs(%{} = flop, opts) when is_list(opts) do
    Faq
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Faq)
  end

  @doc """
  Gets a single faqs.

  Raises `Ecto.NoResultsError` if the Faqs does not exist.

  ## Examples

      iex> get_faqs!(123)
      %Faqs{}

      iex> get_faqs!(456)
      ** (Ecto.NoResultsError)

  """
  def get_faq!(id), do: Repo.get!(Faq, id)

  @doc """
  Creates a faqs.

  ## Examples

      iex> create_faqs(%{field: value})
      {:ok, %Faqs{}}

      iex> create_faqs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_faq(attrs \\ %{}) do
    %Faq{}
    |> Faq.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a faqs.

  ## Examples

      iex> update_faqs(faqs, %{field: new_value})
      {:ok, %Faqs{}}

      iex> update_faqs(faqs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_faq(%Faq{} = faq, attrs) do
    faq
    |> Faq.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a faqs.

  ## Examples

      iex> delete_faqs(faqs)
      {:ok, %Faqs{}}

      iex> delete_faqs(faqs)
      {:error, %Ecto.Changeset{}}

  """
  def delete_faq(%Faq{} = faq) do
    Repo.delete(faq)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking faqs changes.

  ## Examples

      iex> change_faqs(faqs)
      %Ecto.Changeset{data: %Faqs{}}

  """
  def change_faq(%Faq{} = faq, attrs \\ %{}) do
    Faq.changeset(faq, attrs)
  end

  alias Parzival.Tools.Announcement

  @doc """
  Returns the list of announcements.

  ## Examples

      iex> list_announcements()
      [%Announcement{}, ...]

  """
  def list_announcements(params \\ %{})

  def list_announcements(opts) when is_list(opts) do
    Announcement
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_announcements(flop) do
    Flop.validate_and_run(Announcement, flop, for: Announcement)
  end

  def list_announcements(%{} = flop, opts) when is_list(opts) do
    Announcement
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Announcement)
  end

  @doc """
  Gets a single announcement.

  Raises `Ecto.NoResultsError` if the Announcement does not exist.

  ## Examples

      iex> get_announcement!(123)
      %Announcement{}

      iex> get_announcement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_announcement!(id, preloads \\ []),
    do: Repo.get!(Announcement, id) |> Repo.preload(preloads)

  @doc """
  Creates a announcement.

  ## Examples

      iex> create_announcement(%{field: value})
      {:ok, %Announcement{}}

      iex> create_announcement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_announcement(attrs \\ %{}) do
    %Announcement{}
    |> Announcement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a announcement.

  ## Examples

      iex> update_announcement(announcement, %{field: new_value})
      {:ok, %Announcement{}}

      iex> update_announcement(announcement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_announcement(%Announcement{} = announcement, attrs) do
    announcement
    |> Announcement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a announcement.

  ## Examples

      iex> delete_announcement(announcement)
      {:ok, %Announcement{}}

      iex> delete_announcement(announcement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_announcement(%Announcement{} = announcement) do
    Repo.delete(announcement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking announcement changes.

  ## Examples

      iex> change_announcement(announcement)
      %Ecto.Changeset{data: %Announcement{}}

  """
  def change_announcement(%Announcement{} = announcement, attrs \\ %{}) do
    Announcement.changeset(announcement, attrs)
  end

  alias Parzival.Tools.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(params \\ %{})

  def list_posts(opts) when is_list(opts) do
    Post
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_posts(flop) do
    Flop.validate_and_run(Post, flop, for: Post)
  end

  def list_posts(%{} = flop, opts) when is_list(opts) do
    Post
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:new_post)
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  def subscribe(topic) when topic in ["new_post"] do
    Phoenix.PubSub.subscribe(Parzival.PubSub, topic)
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Post{} = post}, event)
       when event in [:new_post] do
    Phoenix.PubSub.broadcast!(Parzival.PubSub, "new_post", {event, post})
    {:ok, post}
  end
end
