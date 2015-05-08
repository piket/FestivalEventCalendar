$(function(){


  $('.uk-search').submit(function(e){

    console.log("inside search field function")
    e.preventDefault();
    arr= $(this).children().val().toLowerCase().split(/[ ,-\/:\&"']/)

    festivals = $('.each-festival')
    unmatches = festivals.filter(function(j,festival){
      for (var i=0; i<arr.length; i++) {
        if ($(festival).hasClass(arr[i]) || $(festival).children('.location').text().toLowerCase().indexOf(arr[i]) !== -1 || $(festival).children('.name').text().toLowerCase().indexOf(arr[i]) !== -1) {
          return false
        }
      }
      return true
    })
    console.log(unmatches);
    // $(festivals).hide();
    $(unmatches).hide();

  })






  console.log("HERRO")

})