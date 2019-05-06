defmodule MeadowUiWeb.ImagesControllerTest do
  # use Meadow.Data.RepoCase
  use MeadowUiWeb.ConnCase
  use Meadow.Data.RepoCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Repository - Objects"
  end
end
