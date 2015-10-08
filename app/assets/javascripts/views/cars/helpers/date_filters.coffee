@module "Cars", ->
  class @Dates
    @initialize_filters : () ->
      $('#filter_by_date .time').timepicker({
          'showDuration': true,
          'timeFormat': 'H:i',
      });

      # init date with 00:00
      midnight = new Date();
      midnight.setHours(0,0,0,0);

      # set up default start time at midnight
      if $('.start_time').val().length == 0
          $('#filter_by_date .start_time').timepicker('setTime', midnight);


      # set up default end time as right now
      if $('.end_time').val().length == 0
          $('#filter_by_date .end_time').timepicker('setTime', new Date());


      $('#filter_by_date .date').datepicker({
          'format': 'd/m/yyyy',
          'autoclose': true
      });

      # set up start date as today 
      if $('.start_date').val().length == 0
          $('.start_date').datepicker('setDate', new Date())

      # set up end date as today
      if $('.end_date').val().length == 0
          $('.end_date').datepicker('setDate', new Date())

      basicExampleEl = document.getElementById('filter_by_date');
      datepair = new Datepair(basicExampleEl); 