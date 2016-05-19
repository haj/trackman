window.Views.Home ||= {}
class Views.Home.IndexView extends Views.ApplicationView

	# connect: ->
	# 	window.socket = io.connect('http://0.0.0.0:5001')
	# 	window.socket.on 'rt-change', (message) ->
	# 	# publish the change on the client side, the channel == the resource
	# 		alert message
	# 		console.log message
	# 		window.trigger message.resource, message


	render: ->
		super()

		# @connect()

		$(".page-content").css("overflow", "hidden")

		$(".page-content .content").css("padding-top", "61px")
		.css("padding-left", "0px")
		.css("padding-right", "0px")

		$('#apply_date_filter').click ->
			start_date = $('.datepicker.start-date').val()
			end_date = $('.datepicker.end-date').val()
			start_time = $('.timepicker.start-time').val()
			end_time = $('.timepicker.end-time').val()
			filters =
				start_date: start_date
				end_date: end_date
				start_time: start_time
				end_time: end_time
			$.ajax
				url: '/apply_filter'
				type: 'get'
				data: filters
				success: (data) ->
					if data == 'OK'
						showSuccess 'Filters applied.'
					# window.location.href = "#logbook"
					return
				error: ($xhr) ->
					data = $xhr.responseJSON
					console.log data
					return
			return

		# $('.show_logbook').click ->
		#   alert 'started'
		#   car_id = $(this).data('car-id')
		#   car_name = $(this).data('car-name')
		#   car_last_seen = $(this).data('car-last-seen')
		#   start_date = $('.datepicker.start-date').val()
		#   end_date = $('.datepicker.end-date').val()
		#   gon.watch 'pin', { url: '/one_car_render_pin?car_id=' + car_id }, show_car
		#   $('.map-title').empty().html 'Last location of ' + car_name + ' <small>| ' + car_last_seen + ' ago</small>'
		#   $('.map-road-details').empty().hide()
		#   $.ajax
		#     url: '/logbook_render'
		#     type: 'GET'
		#     data: car_id: car_id
		#     success: (data) ->
		#       window.location.href = '#logbook'
		#       return
		#     error: ($xhr) ->
		#       data = $xhr.responseJSON
		#       console.log data
		#       return
		#   return

		$('.timepicker').timepicker {}
		$('.datepicker').datepicker
			format: 'dd/mm/yyyy'
			todayBtn: 'linked'

		$('.page-sidebar').css 'height', $('.page-content').css('height')

		$('.sortable').sortable
			connectWith: '.sortable'
			iframeFix: true
			items: '.dragme'
			opacity: 0.8
			helper: 'original'
			revert: true
			forceHelperSize: true
			placeholder: 'sortable-box-placeholder round-all'
			forcePlaceholderSize: true
			tolerance: 'pointer'
		return

			# if (typeof gon != "undefined") && gon.resource == "cars" && gon.map_id == "cars_index"

		# $(".toggle").click ->
		#     $(".to-be-toggled").fadeToggle( "fast", "linear" )
