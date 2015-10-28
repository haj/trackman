window.Views.Home ||= {}
class Views.Home.IndexView extends Views.ApplicationView
  render: ->
    super()

    Cars.Show.all()

    # show_road = (data) ->
    #   Cars.Maps.switch_to_directions data
    #   return

    $('.show-on-map').click ->
      Cars.Maps.focus_position $(this).parent().parent().data('lat'), $(this).parent().parent().data('lng')
      return

    # $('.show_road_for_this_date').click ->
    #   alert 'kaka'
    #   car_id = $(this).data('car-id')
    #   date = $(this).text()
    #   gon.watch 'road', { url: '/one_car_render_directions?car_id=' + car_id + '&date=' + date }, show_road
    #   # $('.map-title').empty().html 'Route of ' + car_name + ' <small>| ' + date + '</small>'
    #   return

    $('.expand_positions').click ->
      date = $(this).data('date')
      if $('tr.' + date).css('display') != 'none'
        $('tr.' + date).hide()
        $(this).find('i').removeClass 'fa-minus-circle'
        $(this).find('i').addClass 'fa-plus-circle'
      else
        $('tr.' + date).show()
        $(this).find('i').removeClass 'fa-plus-circle'
        $(this).find('i').addClass 'fa-minus-circle'
      return

    sizeMapFull = ->
      $('.map').css 'width', '100%'
      $('.overview').css 'width', '100%'
      return

    sizeMapLess = ->
      $('.map').css 'width', '50%'
      $('.overview').css 'width', '50%'
      return

    show_car = (data) ->
      Cars.Show.one data
      return

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

    $('a.config.sizeMapFull-icon').click ->
      if $('.map').attr('style') == 'width: 50%;'
        sizeMapFull()
        setTimeout (->
          Cars.Maps.refresh()
          return
        ), 500
      else
        sizeMapLess()
      return

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
