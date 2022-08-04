defmodule Toolbox.EfrontRepo do
  use Ecto.Repo,
    otp_app: :toolbox,
    adapter: Ecto.Adapters.Tds,
    read_only: true
end
