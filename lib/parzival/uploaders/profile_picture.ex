defmodule Parzival.Uploaders.ProfilePicture do
  @moduledoc """
  ProductImage is used for product images.
  """

  use Waffle.Definition
  use Waffle.Ecto.Definition

  alias Parzival.Accounts.User
  alias Parzival.Companies.Company

  @versions [:original, :medium, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  def validate({file, _}) do
    file.file_name
    |> Path.extname()
    |> String.downcase()
    |> then(&Enum.member?(@extension_whitelist, &1))
    |> case do
      true -> :ok
      false -> {:error, "invalid file type"}
    end
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 100x150^ -gravity center -extent 100x150 -format png", :png}
  end

  def transform(:medium, _) do
    {:convert, "-strip -thumbnail 400x400^ -gravity center -extent 400x400 -format png", :png}
  end

  def filename(version, _) do
    version
  end

  def storage_dir(_version, {_file, %User{} = scope}) do
    "uploads/profile/#{scope.id}"
  end

  def storage_dir(_version, {_file, %Company{} = scope}) do
    "uploads/company/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version) do
  #   "/images/defaults/store/product_image_#{version}.png"
  # end
end
