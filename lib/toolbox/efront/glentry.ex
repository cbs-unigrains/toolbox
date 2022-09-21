defmodule Toolbox.Efront.Glentry do
  use Ecto.Schema

  @primary_key {:iqid, :string, autogenerate: false}
  schema "GLENTRY" do
    field :operation_id, :string, source: :KEYID3
    field :locked, :string, source: :USERTEXT2
  end
end
