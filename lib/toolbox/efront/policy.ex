defmodule Toolbox.Efront.Policy do
  @behaviour Bodyguard.Policy

  def authorize(_action, _user, _params), do: false
end
