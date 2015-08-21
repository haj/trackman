// Framework Requires
//
//= require modularize
//= require ./libraries/jquery-1.8.3.min
//= require ./libraries/jquery-ui-1.10.1.custom.min
//= require ./libraries/bootstrap.min
//= require ./libraries/breakpoints
//= require ./libraries/jquery.unveil.min
//= require ./libraries/jqueryblockui
//= require ./libraries/page/select2.min
//
// Page Requires for a blank_template
//= require ./libraries/page/jquery.sidr.min
//= require ./libraries/page/jquery.slimscroll.min
//= require ./libraries/page/pace.min
//= require ./libraries/page/jquery.animateNumbers
//= require ./libraries/messenger.min
//= require ./libraries/messenger-theme-future
//= require ./libraries/notifications
//
// Page Require for other pages
//= require ./libraries/page/jquery.dataTables.min
//= require ./libraries/page/TableTools.min
//= require ./libraries/datatables.responsive
//= require_directory ./libraries/page
//
// Before Core Require
//= require ./libraries/datatables
//= require ./libraries/messages_notifications
//
// Core Require.
//= require ./libraries/core
//= require ./libraries/chat
//= require ./libraries/demo
//= require ./controllers/helpers/batch_action
//
//
// Our stuff Require.
//= require jquery_nested_form
//= require ./libraries/facebox
//= require ./libraries/best_in_place
//= require ./libraries/bootstrap-datepicker
//= require ./libraries/jquery.timepicker
//= require ./libraries/datepair
//= require chosen-jquery
//= require cocoon
//= require gmaps/google
//= require jquery_ujs
//= require underscore
//= require ./libraries/jquery.regex-selector
//= require ./libraries/jquery.timetable
//= require retina_tag
//
//
// ####################################
//
// Controllers
//
// ####################################
//
//= require ./controllers/home
// ############### Alarms related helpers
//= require ./controllers/alarms/alerts
//= require ./controllers/alarms/regions
//
// ############### Cars related stuff controllers 
//
//= require ./controllers/cars/cars
//= require ./controllers/cars/groups
//
// ############### Cars related helpers  
//
//= require ./controllers/cars/helpers/all_cars
//= require ./controllers/cars/helpers/maps_modes
//= require ./controllers/cars/helpers/date_filters
// 
// ############### Devices related controllers  
//
//= require ./controllers/devices/devices
//
// ############### Plans related controllers  
//
//= require ./controllers/plans/billings
//= require ./controllers/plans/subscriptions
//
// ############### Accounts related controllers  
//
//= require ./controllers/accounts/conversations
//
// ###############  Work schedules related controllers  
//
//= require ./controllers/work_schedules/work_schedules
//

function sizeMapFull(){
     $('.map').css("width","100%");
     $('.overview').css("width","100%");
}

function sizeMapLess(){
     $('.map').css("width","50%");
     $('.overview').css("width","50%");
}

$(document).ready(function(){

          show_car = function(data){
               Cars.Maps.switch_to_pins(data)
          }

          $('.show_logbook').click(function() {
               car_id = $(this).data('car-id')
               car_name = $(this).data('car-name')
               gon.watch('data', {url: '/one_car_render_pin?car_id='+car_id}, show_car)
               $('.map-title').empty().html('Showing location of <strong>'+car_name+'</strong>')
               $.ajax({
                    url: '/logbook_render',
                    type: 'GET',
                    data: {car_id: car_id},
                    success: function(data){
                         // window.location.href = "#logbook"
                    },
                    error: function($xhr){
                         var data = $xhr.responseJSON;
                         console.log(data);
                    }
               })
          });

          $('a.config.sizeMapFull-icon').click(function(){
               if($('.map').attr('style') == "width: 50%;") {
                    sizeMapFull();
                    setTimeout(function(){
                         Cars.Maps.refresh();
                    }, 500)
               } else { sizeMapLess(); }
          });

          $('.timepicker').timepicker();

          $('.timepicker.start-time').timepicker('setTime', '08:00');
          $('.timepicker.end-time').timepicker('setTime', '12:00');

          $('.datepicker').datepicker({format: 'dd/mm/yyyy', todayBtn: "linked", initialDate: new Date()});

		$('.page-sidebar').css('height',$('.page-content').css('height'))

		$(".sortable").sortable({
          connectWith: '.sortable',
          iframeFix: true,
          items: '.dragme',
          opacity: 0.8,
          helper: 'original',
          revert: true,
          forceHelperSize: true,
          placeholder: 'sortable-box-placeholder round-all',
          forcePlaceholderSize: true,
          tolerance: 'pointer'
      	});

	})


