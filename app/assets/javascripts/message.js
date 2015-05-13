$(function() {


    $('#message-modal').on('click', '.each-friend', function(e){
        e.preventDefault();

        var btn = $(this)

        $.ajax({
          url: '/message/new',
          method: 'GET',
          data: {
            id: btn.attr('data')
          }
        }).done(function(form){
            $('.modal-body').html(form)
            // console.log(form)
            if($(location).attr('pathname').indexOf('inbox') !== -1) {
            $('#new_comment').attr('id','new_comment_inbox');
          }

        }).error(function(err){
            console.log('ERROR:',err)
        })

    })



})