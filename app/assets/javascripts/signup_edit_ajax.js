$(function(){

    console.log('ajax loaded');

    var profContainer = $('.prof-container');

    profContainer.on('click','.prof-edit-btn',function(e) {
        console.log('clicked')
        e.preventDefault();

        var btn = $(this);

        $.ajax({
            url: btn.attr('href'),
            method: 'GET',
        }).done(function(render){
            profContainer.html(render);
        }).error(function(err){
            console.log(err);
        })
    });

    profContainer.on('submit','.edit_user',function(e) {
        e.preventDefault();

        var form = $(this);

        $.ajax({
            url: form.attr('action'),
            method: 'PATCH',
            data: form.serialize()
        }).done(function(render){
            profContainer.html(render);
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
        }).error(function(err){
            console.log(err);
        })
    })

});