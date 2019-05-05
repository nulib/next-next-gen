defmodule Meadow.Data do
  alias Meadow.Data.{Repo, Image}
  import Ecto.Query, warn: false

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Images{}, ...]

  """
  def list_images do
    Repo.all(Image)
  end

  @doc """
  Creates an image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(images)
      %Ecto.Changeset{source: %Images{}}

  """
  def change_image(%Image{} = image) do
    Image.changeset(image, %{})
  end

  @doc """
  Updates an image.

  ## Examples

      iex> update_image(image, %{field: new_value})
      {:ok, %Image{}}

      iex> update_image(image, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Images does not exist.

  ## Examples

      iex> get_image!(123)
      %Images{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id), do: Repo.get!(Image, id) |> Repo.preload(:file_sets)
end
