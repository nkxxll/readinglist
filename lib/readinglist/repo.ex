defmodule Readinglist.Repo do
  use Ecto.Repo,
    otp_app: :readinglist,
    adapter: Ecto.Adapters.SQLite3
end
