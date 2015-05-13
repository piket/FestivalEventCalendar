$(document).ready(function() {

    // page is now ready, initialize the calendar...

    var get_url = [$(location).attr('pathname')]
    console.log(get_url[0])

    if (get_url[0].indexOf('compare') !== -1) {
        console.log("compare page");
        first_url = get_url[0].substring(0,get_url[0].indexOf('/compare')) + '/get_events/';
        second_url = '/users/' + get_url[0].substr(get_url[0].indexOf('compare/')+8) + get_url[0].substring(get_url[0].indexOf('/calendars'),get_url[0].indexOf('/compare')+8) + '/get_events/';
        get_url = [first_url,second_url];
        console.log(get_url)
    }
    else if (get_url[0].substr(get_url[0].indexOf('calendars')+10) !== "") {
        get_url[0] += "/get_events/";
        console.log("show page")
    } else {
        get_url[0] += "/all_events";
        console.log("my calendars page")
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
        timeFormat: 'h(:mm)t',
        eventSources: get_url,
        defaultDate: $('#my-calendar').attr('data')
            });

    $('#calendar').on('click','.my-event',function(e) {
        e.preventDefault();
        console.log('clicked!')
    });


    // ADD EVENT TO CONSUMER SCHEDULE
  $('#calendar').on('click', '.friend-event', function(e){
    e.preventDefault();

    var btn = $(this);
    var nextBtn = btn.next('.my-event')
    var friendId = btn.attr('href').substr(btn.attr('href').indexOf('addevent/')+9);
    var myId = nextBtn.substr(nextBtn.attr('href').indexOf('deleteevent/')+12);

    if (friendId == myId) {
        console.log('you already have this event');
    } else {
        console.log('adding event');
        // $.ajax({
        //   url: btn.attr('href'),
        //   method: 'PATCH',
        //   dataType: 'json'
        // }).done(function(data){

        //   if (data) {
        //     btn.removeClass('add-btn').addClass('del-btn').text('x').attr('href','/deleteevent/'+ data)
        //   }
        //   console.log(data)
        // }).error(function(err){
        //   console.log("ERROR" + err);
        //   alert('Error! Unable to add event to your calendar.');
        // })
    }


  })

  // DELETE EVENT FROM CONSUMER SCHEDULE

  $('body').on('click', '.del-btn', function(e){
    e.preventDefault();

    var btn = $(this);

    $.ajax({
      url: btn.attr('href'),
      method: 'DELETE',
      dataType: 'json'
    }).done(function(data){

      if (data) {
        btn.removeClass('del-btn').addClass('add-btn').text('+').attr('href','/addevent/'+ data)
      }
      console.log(data)
    }).error(function(err){
      console.log("ERROR" + err);
      alert('Error! Unable to delete event to your calendar.');
    })

  })

});