$(function() {

    $('.event-container').slideUp();

    $('.each-myfestival').on('click','.view-events',function(e) {
        e.preventDefault();

        var btn = $(this);

        $.ajax({
            url: btn.attr('href'),
            method: 'GET'
        }).done(function(view) {
            btn.prev('.event-container').html(view).slideDown();
            btn.removeClass('view-events').addClass('close-view-events').html('CLOSE EVENTS <i class="uk-icon-chevron-up"></i>');
        }).error(function(err) {
            console.log(err);
        });
    });

    $('.each-myfestival').on('click','.close-view-events',function(e) {
        e.preventDefault();

        var btn = $(this);
        btn.removeClass('close-view-events').addClass('view-events').html('YOUR EVENTS <i class="uk-icon-chevron-down"></i>');
        btn.prev('.event-container').slideUp(function(){
            $(this).html('');
        });

    });

})