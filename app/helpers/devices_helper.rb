module DevicesHelper
  def no_available_simcards?
    Simcard.available_simcards.count == 0 
  end

  def list_available_simcards
    select_tag('device[simcard_id]', content_tag(:option,'Select Simcard ...', :value=>"")+options_from_collection_for_select(Simcard.available_simcards, 'id', 'name'), class: "form-control")
  end

  def list_no_available_simcards
    select_tag('device[simcard_id]', content_tag(:option,'No available simcards', :value=>""), class: "form-control")
  end

  def list_simcards_with_default(simcard)
    select_tag('device[simcard_id]', content_tag(:option, simcard.name, :value=> simcard.id )+options_from_collection_for_select(Simcard.available_simcards, 'id', 'name'), class: "form-control")
  end
end
