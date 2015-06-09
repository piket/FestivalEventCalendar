$(document).ready(function() {

    // page is now ready, initialize the calendar...

    var calendar = $('#calendar');

    var get_url = [$(location).attr('pathname')]
    console.log(get_url[0])

    if (get_url[0].indexOf('compare') !== -1) {
        console.log("compare page");
        first_url = get_url[0].substring(0,get_url[0].indexOf('/compare')) + '/get_friend_events/';
        second_url = '/users/' + get_url[0].substr(get_url[0].indexOf('compare/')+8) + get_url[0].substring(get_url[0].indexOf('/calendars'),get_url[0].indexOf('/compare')+8) + '/get_events/';
        get_url = [second_url,first_url];
        console.log(get_url)
    }
    else if (get_url[0].substr(get_url[0].indexOf('calendars')+10) !== "") {
        if ($('#my-calendar').attr('data-type') == "friend") {
            get_url[0] += '/get_friend_events';
        } else {
            get_url[0] += "/get_events/";
        }
        console.log("show page")
    } else {
        get_url[0] += "/all_events";
        console.log("my calendars page")
    }

    var url = null;


    var addEvent = function() {
        console.log(url);
            console.log('adding event');
            $.ajax({
              url: url,
              method: 'PATCH',
              dataType: 'json'
            }).done(function(data){

              if (data.result) {
                calendar.fullCalendar('refetchEvents');
                UIkit.notify('New event added to your calendar!',{status:'success'});
              }
              console.log(data)
            }).error(function(err){
              console.log("ERROR" + err);
              UIkit.notify('Error! Unable to add event to your calendar.',{status:'danger'});
            });
    }

    var deleteEvent = function() {
        console.log(url);
        $.ajax({
              url: url,
              method: 'DELETE',
              dataType: 'json'
        }).done(function(data){

              if (data.result) {
                calendar.fullCalendar('refetchEvents');
                UIkit.notify('Event deleted from your calendar.',{status:'warning'});
              }
              console.log(data)
        }).error(function(err){
              console.log("ERROR" + err);
              UIkit.notify('Error! Unable to delete event to your calendar.',{status:'danger'});
        });
    }

    var confirmAction = function(e) {
        console.log(e);

        if (e.className[0] == "friend-event") {
            var exists = false;
            var friendId = e.url.substr(e.url.indexOf('addevent/')+9);

            var items = $('.my-event')
            for(var i = 0; i < items.length; i++) {
                var item = $(items[i])
                var itemId = item.attr('href').substr(item.attr('href').indexOf('deleteevent/')+12)
                if (itemId == friendId) {
                    exists = true;
                }
            }

            if (exists) {
                console.log('you already have this event');
            } else {
                // if (confirm("Add "+e.title+" to your calendar?")) {
                    url = e.url;
                    UIkit.modal.confirm("Are you sure you want to add "+e.title+" to your calendar?",addEvent)
                    $('.js-modal-confirm').text('Yes').next('.uk-modal-close').text('No');
                // }
            }
            return false
        } else if (e.className[0] == "my-event") {
          url = e.url;
          UIkit.modal.confirm("Are you sure you want to delete "+e.title+" from your calendar?",deleteEvent);
          $('.js-modal-confirm').text('Yes').next('.uk-modal-close').text('No');
            // if (confirm("Delete "+e.title+" from your calendar?")) {
            //     deleteEvent(e.url);
            // }
            return false;
        }
    }

    calendar.fullCalendar({
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
        defaultDate: $('#my-calendar').attr('data'),
        eventClick: confirmAction
            });

    // calendar.on('click','.my-event',function(e) {
    //     e.preventDefault();
    //     console.log('clicked!')
    // });



    // ADD EVENT TO CONSUMER SCHEDULE
  // calendar.on('click', '.friend-event', function(e){
  //   e.preventDefault();

  //   var btn = $(this);
  //   var exists = false;
  //   var friendId = btn.attr('href').substr(btn.attr('href').indexOf('addevent/')+9);

  //   var items = $('.my-event')
  //   for(var i = 0; i < items.length; i++) {
  //       var item = $(items[i])
  //       var itemId = item.attr('href').substr(item.attr('href').indexOf('deleteevent/')+12)
  //       if (itemId == friendId) {
  //           exists = true;
  //       }
  //   }

  //   if (exists) {
  //       console.log('you already have this event');
  //   } else {
  //       console.log('adding event');
  //       $.ajax({
  //         url: btn.attr('href'),
  //         method: 'PATCH',
  //         dataType: 'json'
  //       }).done(function(data){

  //         if (data.result) {
  //           calendar.fullCalendar('refetchEvents');
  //         }
  //         console.log(data)
  //       }).error(function(err){
  //         console.log("ERROR" + err);
  //         alert('Error! Unable to add event to your calendar.');
  //       })
  //   }
  // })

  // DELETE EVENT FROM CONSUMER SCHEDULE

//   calendar.on('click', '.my-event', function(e){
//     e.preventDefault();

//     var btn = $(this);

//     console.log('deleted')

//     $.ajax({
//       url: btn.attr('href'),
//       method: 'DELETE',
//       dataType: 'json'
//     }).done(function(data){

//       if (data.result) {
//         calendar.fullCalendar('refetchEvents');
//       }
//       console.log(data)
//     }).error(function(err){
//       console.log("ERROR" + err);
//       alert('Error! Unable to delete event to your calendar.');
//     })

//   })

});