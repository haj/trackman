module SimcardsHelper
	def all_teleproviders
		return Teleprovider.all.collect {|a| [ a.name, a.id ] }
	end
end
