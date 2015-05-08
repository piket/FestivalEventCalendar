$(function(){


  $('.uk-search').submit(function(e){

    console.log("inside search field function")
    e.preventDefault();
    arr= $(this).children().val().toLowerCase().split(/[ ,-\/:\&"']/)

    var formId = $(this).attr('id');

    if(formId == 'event_filter') {
      items = $('.each-event')
    } else {
      items = $('.each-festival')
    }

    if(arr.length == 1 && arr[0] == "") {
      items.show();
    } else {

    unmatches = items.filter(function(j,item){
      var classes = $(item).attr('data-tags').toLowerCase()
      for (var i=0; i<arr.length; i++) {
        if (classes.indexOf(arr[i]) !== -1 || $(item).children('.location').text().toLowerCase().indexOf(arr[i]) !== -1 || $(item).children('.name').text().toLowerCase().indexOf(arr[i]) !== -1) {
          return false
        } //else if (formId == 'event_filter' && new Date($(item).children('.date').text())
      }
      return true
    })
    console.log(unmatches);
    // $(items).hide();
    $(unmatches).hide();

    }
  })






  console.log("HERRO")

})