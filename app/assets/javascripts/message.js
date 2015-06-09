$(function() {

    var msgModal = UIkit.modal('#message-modal');

    $('.message-modal-body').on('click', '.list-each-friend', function(e){
        console.log("clicked friend")
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

            $('.new_comment #comment_subject').focus();
        }).error(function(err){
            console.log('ERROR:',err)
        })

    });

    msgModal.on('hide.uk.modal',function(){
        $.ajax({
            url: '/friends/list',
            method: 'GET'
        }).done(function(friendsList) {
            // console.log(friendsList)
            $('.message-modal-body').html(friendsList);
        }).error(function(err){
            console.log(err);
        });
    });

    $('.send-message-btn').click(function(e) {
        var id = $(this).attr('data-id')

        $.ajax({
            url: '/message/new',
            method: 'GET',
            data: { id: id}
        }).done(function(form) {
            $('.modal-body').html(form);
            $('#new_comment #comment_subject').focus();
        }).error(function(err) {
            console.log(err);
        })
    })



})