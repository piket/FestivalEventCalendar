$(function(){

    $('.alert-message').each(function() {
        var type = $(this).attr('data-type');
        var msg = $(this).html();
        console.log(type,msg)
        UIkit.notify({
            status: type,
            message: msg,
            timeout: 8000,
            pos: 'top-center'
        });
    });

    console.log('ajax loaded');

    var profContainer = $('.profile');
    var editContainer = $('.edit-container');
    editContainer.hide();

    profContainer.on('click','#edit-prof-btn',function(e) {
        e.preventDefault();
        console.log('clicked')
        profContainer.hide();
        editContainer.show();
        $('#user_name').focus();

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
            url: link.attr('data-href'),
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