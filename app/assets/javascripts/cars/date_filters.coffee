@module "Cars", ->
    class @Dates
        @initialize_filters : () ->
            $('#filter_by_date .time').timepicker({
                'showDuration': true,
                'timeFormat': 'H:i',
            });

            date = new Date();
            date.setHours(6,0,0,0);

            if $('.start_time').val().length == 0
                $('#filter_by_date .start_time').timepicker('setTime', date);

            if $('.end_time').val().length == 0
                $('#filter_by_date .end_time').timepicker('setTime', new Date());


            $('#filter_by_date .date').datepicker({
                'format': 'd/m/yyyy',
                'autoclose': true
            });

            # if $('.limit_results').val().length == 0
            #     $('.limit_results').val('20')

            if $('.start_date').val().length == 0
                $('.start_date').datepicker('setDate', new Date())

            if $('.end_date').val().length == 0
                $('.end_date').datepicker('setDate', new Date())

            basicExampleEl = document.getElementById('filter_by_date');
            datepair = new Datepair(basicExampleEl); 