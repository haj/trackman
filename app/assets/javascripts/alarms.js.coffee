
$(document).ready ->


	$("#rules").on "change", "select:regex(id, .*alarm_rules_attributes.*_id)", ->	
		regex_numbers = /\d+/;
		
		console.log('Change on select with id = ' + $(this).attr('id').match(regex_numbers))
		
		#param_field = $(this).parent().next('div[.params]').children('input')
		
		rule_id = $(this).attr('id').match(regex_numbers)

		params_block = $(this).parent().parent().find('.params')			


		$.ajax "/rules/#{$(this).val()}/rule_params_list",
			success: (response) ->
						  
				params_block.empty()
				
				for param in response
					# console.log(param)
					name = String(param.name)

					# check if region_id, show a select list 
					if param.name == 'region_id'
						$.ajax "/rules/regions",
							success: (response) ->
								list_id = "alarm_rules_attributes_" + rule_id + "_params_" + name
								list_name = "alarm[rules_attributes][" + rule_id + "][params][" + name + "]"
								regionsList = $("<select></select>").attr("id", list_id).attr("name", list_name)

								#console.log(regionsList)

								for region in response 
									regionsList.append("<option value='" + region.id + "'>" + region.name + "</option>");


								#console.log(regionsList.html())
								
								field_element = $("<div class='field'> Regions : </div>")

								params_block.append(field_element.append(regionsList))

							complete: (response) ->
								#console.log(response)
							error: ->
								alert("Error")
					
					else 
						input_element = "<div class='form-group'><input id='alarm_rules_attributes_" + rule_id + "_params_" + name + "' name='alarm[rules_attributes][" + rule_id + "][params][" + name + "]' type='text'></div>"	  	
						label_element = "<div class='form-group'>"+ String(param.description) + "</div>"
						field_element = $("<div class='field'>" + label_element + input_element + "</div>")
						params_block.append(field_element)

			complete: (response) ->
				#console.log("complete")
				#$("#ajax_tell").removeClass "is-fetching"

			error: ->
				alert("ERROR")
		

	$("#rules").on("cocoon:after-insert", ->
		$('.nested-fields:first > .conjunction_row').remove()

	).on "cocoon:after-remove", (e, removedItem) ->
		$('#rules .panel-default').each (index) ->
			
			nested_fields = $(this).find('.nested-fields')

			if nested_fields.length == 0
				$(this).remove()		
	
		$('.nested-fields:first > .conjunction_row').remove()
	
	


		
	


	