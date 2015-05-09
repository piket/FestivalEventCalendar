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

      if (data) {
        btn.removeClass('add-btn').addClass('del-btn').text('x').attr('href','/deleteevent/'+ data)
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

      if (data) {
        btn.removeClass('del-btn').addClass('add-btn').text('+').attr('href','/addevent/'+ data)
      }
      console.log(data)
    }).error(function(err){
      console.log("ERROR" + err);
      alert('Error! Unable to delete event to your calendar.');
    })

  })






  console.log("Page loaded.")
})