defmodule MeadowUiWeb.ImagesController do
  use MeadowUiWeb, :controller

  def index(conn, _params) do
    images = Meadow.Data.list_images()
    render(conn, "index.html", images: images)
  end

  def show(conn, %{"id" => id}) do
    image = Meadow.Data.get_image!(id)
    render(conn, "show.html", image: image)
  end
end
