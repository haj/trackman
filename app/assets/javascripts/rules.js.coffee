# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
	$("#rules").on "change", "select:regex(id, .*alarm_rules_attributes.*)", ->	
		regex_numbers = /\d+/;
		
		console.log('Change on select with id = ' + $(this).attr('id').match(regex_numbers))
		param_field = $(this).parent().next('div').children('input')
		#console.log(param_field)
		
		select_id = $(this).attr('id').match(regex_numbers)

		params_block = $(this).parent().parent().children('.params')

		$.ajax "/rules/#{$(this).val()}/rule_params_list",
			success: (response) ->
						  
				params_block.empty()

				
				for obj in response
					name = String(obj.name)
					input_element = "<input id='alarm_rules_attributes_" + select_id + "_params_" + name + "' name='alarm[rules_attributes][" + select_id + "][params][" + name + "]' type='text'>"	  	
					field_element = $("<div class='field'>" + String(obj.name) + " : " + input_element + "</div>")
					params_block.append(field_element)
				
			  

			complete: (response) ->
				console.log("complete")
				#$("#ajax_tell").removeClass "is-fetching"

			error: ->
				alert("ERROR")
		

	###
	$("#rules").on "cocoon:after-insert", (e, insertedItem) ->
		#el = $("select:regex(id, .*alarm_rules_attributes.*)")
		#console.log(el)
	###


	