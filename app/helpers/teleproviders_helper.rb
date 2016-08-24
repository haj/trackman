module TeleprovidersHelper
  def all_teleproviders
    Teleprovider.all.collect {|a| [ a.name, a.id ] }
  end
end
