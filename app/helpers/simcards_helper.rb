module SimcardsHelper
	def all_simcards
		return Simcard.all.collect {|a| [ a.name, a.id ] }
	end
end
