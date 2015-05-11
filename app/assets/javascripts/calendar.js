$(document).ready(function() {

    // page is now ready, initialize the calendar...

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
        timeFormat: 'h(:mm)tt'
            })

});