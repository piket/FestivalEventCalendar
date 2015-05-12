$(document).ready(function() {

    // page is now ready, initialize the calendar...

    var get_url = '/calendars/all_events/'

    if ($('#hidden-data').is('div')) {
        get_url= "/calendars/get_events/"+ $('#hidden-data').attr('data')+ "/";
        console.log(get_url)
    }

    $('#calendar').fullCalendar({
        // put your options and callbacks here

        defaultView: 'agendaDay',
        minTime: '00:00:00',
        slotMinutes: 15,
        header: {
            // left: 'prev,next',
            // center: 'title',
            // right: 'month,agendaWeek,agendaDay'
        },
        timeFormat: 'h(:mm)tt',
        events: get_url
            })

});