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

    });

    $('#send-message-btn').click(function(e) {
        var id = $(this).attr('data-id')

        $.ajax({
            url: '/message/new',
            method: 'GET',
            data: { id: id}
        }).done(function(form) {
            $('.modal-body').html(form)
        }).error(function(err) {
            console.log(err);
        })
    })



})