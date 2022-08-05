defmodule Toolbox.Cldr do
  use Cldr,
    locales: [:fr],
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime]
end
