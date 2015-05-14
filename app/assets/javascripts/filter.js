$(function(){

  var dateComp = function(date,input) {
    var dateStr = date.split(' ');
    dateStr[1] = parseInt(dateStr[1]);
    dateStr[2] = parseInt(dateStr[2]);
    // console.log(dateStr[2] == input,dateStr[2],input)
    if (dateStr[0].indexOf(input) !== -1 || (new Date(Date.parse(dateStr[0]+" 1 2000")).getMonth() + 1) === parseInt(input)) {
      // console.log("month match")
      return true;
    } else if (dateStr[1] == input || dateStr[2] == input) {
      // console.log("day/year match")
      return true;
    } else {
      return false;
    }
  }

  var abbrev = function(str,word) {
      return str + word[0];
  }

    var filter = function(e){

      var filterForm = $('.filter-form');

    // console.log("start filter")

    e.preventDefault();
    arr = filterForm.children().val().toLowerCase().split(/[ ,-\/:\&"']/)

    var formId = filterForm.attr('id');

    if(formId == 'event_filter') {
      items = $('.each-event')
    } else {
      items = $('.each-festival')
    }


      items.show();

    unmatches = items.filter(function(j,item){
      var classes = $(item).attr('data-tags').toLowerCase()
      var location = $(item).find('.fest-location').text().toLowerCase();
      var name = $(item).find('.fest-name').text().toLowerCase().trim();
      var nickname = name.split(' ').reduce(abbrev,"")

      console.log(nickname)

      for (var i=0; i<arr.length; i++) {
        if (classes.indexOf(arr[i]) !== -1 || location.indexOf(arr[i]) !== -1 || name.indexOf(arr[i]) !== -1 || nickname.indexOf(arr[i]) !== -1) {
          return false
        } else if (formId == 'event_filter' && dateComp($(item).children('.date').text().toLowerCase(), arr[i])) {
          return false
        }
      }
      return true
    })

    $(unmatches).hide();

  }

  $('.filter-form').on('keyup',filter);
  $('.filter-form').submit(filter);






  console.log("HERRO")

})