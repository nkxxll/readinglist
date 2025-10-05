defmodule ReadinglistWeb.PageController do
  use ReadinglistWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
