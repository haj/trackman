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


$(document).ready(function(){
		$('.page-sidebar').css('height',$('.page-content').css('height'))
	}
)


