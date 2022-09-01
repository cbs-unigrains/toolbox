defmodule Toolbox.Repo.Migrations.CreateSecteurs do
  use Ecto.Migration

  def change do
    create table(:secteurs) do
      add :name, :string

      timestamps()
    end
  end
end
