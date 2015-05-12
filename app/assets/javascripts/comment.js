$(function(){

  default_action = $('#default-action').val($('#new_comment').attr('action'));

    $('#new_comment').submit(function(e){

        e.preventDefault();

        var form = $(this)

        $.ajax({
          url: form.attr('action'),
          method: 'POST',
          data: form.serialize()
        }).done(function(data){
            form.trigger('reset');
            form.attr('action', default_action.val());
            $('.display-container').html(data)
        }).error(function(err){
          console.log(err)
        })

    })

    $('.display-container').on('click', '.reply-btn', function(e){

      e.preventDefault();

      var form = $('#new_comment')

      form.attr('action', $(this).attr('href')).children('#comment_body').focus();
    })







  console.log("I AM READY!")

})