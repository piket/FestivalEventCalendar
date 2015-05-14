$(function(){

    console.log('ajax loaded');

    var profContainer = $('.prof-container');
    var editContainer = $('.edit-container');
    editContainer.hide();

    profContainer.on('click','.prof-edit-btn',function(e) {
        console.log('clicked')
        profContainer.hide();
        editContainer.show();
        $('#user_name').focus();
        e.preventDefault();

        // var btn = $(this);

        // $.ajax({
        //     url: btn.attr('href'),
        //     method: 'GET',
        // }).done(function(render){
        //     profContainer.html(render);
        // }).error(function(err){
        //     console.log(err);
        // })
    });

    profContainer.on('submit','.edit_user',function(e) {
        e.preventDefault();

        var form = $(this);

        $.ajax({
            url: form.attr('action'),
            method: 'PATCH',
            data: form.serialize()
        }).done(function(render){
            profContainer.html(render).show();
            editContainer.hide();
        }).error(function(err){
            console.log(err);
        })
    });

    $('.signup-link').click(function(e) {
        e.preventDefault();

        var link = $(this);

        $.ajax({
            url: link.attr('href'),
            method: 'GET'
        }).done(function(render){
            $('#form-container').html(render);
            $('#form-container input[name="user[name]"]').focus();
            $('.invalid-label').hide();
        }).error(function(err){
            console.log(err);
        })
    });

    var modal = UIkit.modal("#my-id");

    modal.on('show.uk.modal',function(){
        $('#login-form #user_email').focus();
    })

});