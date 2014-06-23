
$(document).ready ->
	$("#rules").on "change", "select:regex(id, .*alarm_rules_attributes.*_id)", ->	
		regex_numbers = /\d+/;
		
		#console.log('Change on select with id = ' + $(this).attr('id').match(regex_numbers))
		
		#param_field = $(this).parent().next('div[.params]').children('input')

		#console.log(param_field)
		
		rule_id = $(this).attr('id').match(regex_numbers)

		params_block = $(this).parent(".field").parent(".nested-fields").children('.params')			


		$.ajax "/rules/#{$(this).val()}/rule_params_list",
			success: (response) ->
						  
				params_block.empty()
				
				for param in response
					#console.log(param)
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
						input_element = "<input id='alarm_rules_attributes_" + rule_id + "_params_" + name + "' name='alarm[rules_attributes][" + rule_id + "][params][" + name + "]' type='text'>"	  	
						field_element = $("<div class='field'>" + String(param.name) + " : " + input_element + "</div>")
						params_block.append(field_element)

			complete: (response) ->
				#console.log("complete")
				#$("#ajax_tell").removeClass "is-fetching"

			error: ->
				alert("ERROR")
		

	$("#rules").on("cocoon:after-insert", ->
		$('.nested-fields:first div:first').css('visibility', 'hidden')

	).on "cocoon:after-remove", (e, removedItem) ->
		$('#rules .panel-default').each (index) ->
			
			has_nested_fields = $(this).find('.nested-fields')

			if has_nested_fields.length == 0
				$(this).remove()		
	
		element = $('#rules .panel-default:first').find('.nested-fields div:first')
		element.css('visibility', 'hidden')
	
	


		
	


	