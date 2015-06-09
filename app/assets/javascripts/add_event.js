$(function(){

// ADD EVENT TO CONSUMER SCHEDULE
  $('body').on('click', '.add-btn', function(e){
    e.preventDefault();

    var btn = $(this);

    $.ajax({
      url: btn.attr('href'),
      method: 'PATCH',
      dataType: 'json'
    }).done(function(data){

      if (data.result) {
        btn.removeClass('add-btn').removeClass('uk-icon-plus').addClass('del-btn').addClass('uk-icon-remove').attr('href','/deleteevent/'+ data.result);
        UIkit.notify('New event added to your calendar!',{status:'success'});
      }
      console.log(data)
    }).error(function(err){
      console.log("ERROR" + err);
      alert('Error! Unable to add event to your calendar.');
    })

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

      if (data.result) {
        btn.removeClass('del-btn').removeClass('uk-icon-remove').addClass('add-btn').addClass('uk-icon-plus').attr('href','/addevent/'+ data.result);
        UIkit.notify('Event deleted from your calendar.',{status:'warning'});
      }
      console.log(data)
    }).error(function(err){
      console.log("ERROR" + err);
      alert('Error! Unable to delete event to your calendar.');
    })

  })

    if($('#event_name').is('input')) {
        $('#event_name').focus();
    }


  $('#new_event').submit(function(e) {
      var valid = true;

      var form_data = $(this).serializeArray();

      for (var i = 2; i < form_data.length; i++) {
          var datum = form_data[i];

          switch (datum.name) {
            case "event[name]":
                if (datum.value === "") {
                  valid = false;
                }
                break;
            case "event[duration]":
              if (isNaN(parseInt(datum.value))) {
                valid = false;
              }
              break;
            case "event[price]":
                if(datum.value !== "" && isNaN(parseFloat(datum.value))) {
                    valid = false;
                }
                break;
            case "event[video]":
                var v = datum.value.indexOf("?v=")
                if (datum.value !== "" && (v === -1 || datum.value.substr(v+4).length > (v+4))) {
                    valid = false;
                }
                break;
            case "event[link]":
            case "event[purchase]":
                var urlReg = new RegExp("^(http|https|ftp)\://([a-zA-Z0-9\.\-]+(\:[a-zA-Z0-9\.&amp;%\$\-]+)*@)*((25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])|([a-zA-Z0-9\-]+\.)*[a-zA-Z0-9\-]+\.(com|edu|gov|int|mil|net|org|biz|arpa|info|name|pro|aero|coop|museum|[a-zA-Z]{2}))(\:[0-9]+)*(/($|[a-zA-Z0-9\.\,\?\'\\\+&amp;%\$#\=~_\-]+))*$")
                if (datum.value !== "" && !urlReg.test(datum.value)) {
                    valid = false
                }
                break;
            default:
              if (datum.name.indexOf("location") !== -1) {
                  if (datum.value === "") {
                      valid = false;
                  }
              } else if (datum.name.indexOf("date") !== -1) {
                  if (datum.value.match(/^(0[1-9]|1[012]|[1-9])[- \/.](0[1-9]|[12][0-9]|3[01]|[1-9])[- \/.](19|20)\d\d$/) === null) {
                      valid = false;
                  }
              } else if (datum.name.indexOf("time") !== -1) {
                  if (datum.value.match(/^(0?[1-9]|1[012])(:[0-5]\d) [APap][mM]$/) === null) {
                      valid = false;
                  }
              }
              break;
          }
          if (!valid) {
            console.log(datum.name,valid)
            break;
          }
      }

      if (!valid) {
          e.preventDefault();
          alert("Invalid information entered");
      }

  })

  $('.import-form-btn').click(function(e){
      // $('#loading-modal').show();
      // e.preventDefault();
      $('#import-form').submit()
  });

  // $('#import-form').submit(function(e){
    // e.preventDefault();
    // console.log("Form submitting...");
  // })


  console.log("Page loaded.")
})