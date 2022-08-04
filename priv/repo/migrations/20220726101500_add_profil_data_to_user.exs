defmodule Toolbox.Repo.Migrations.AddProfilDataToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :display_name, :string
      add :image, :string
    end
  end
end
