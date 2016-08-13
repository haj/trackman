module SimcardsHelper
  def all_simcards
    Simcard.all.collect {|a| [ a.name, a.id ] }
  end
end
