$(function() {

    $('#friends-dashboard').on('click', '.remove-friend-btn', function(e) {
        e.preventDefault();

        var btn = $(this);

        $.ajax({
            url: btn.attr('href'),
            method: 'DELETE'
        }).done(function(data) {
            $('#friends-dashboard').html(data);
        }).error(function(err) {
            console.log("Delete error:",err);
        });
    });

    $('#friends-dashboard').on('click', '.accept-friend-btn', function(e) {
        e.preventDefault();

        var btn = $(this);

        $.ajax({
            url: btn.attr('href'),
            method: 'PATCH'
        }).done(function(data) {
            $('#friends-dashboard').html(data);
        }).error(function(err) {
            console.log("Accept error:",err);
        });
    });

    $('#friends-dashboard').on('click', '.decline-friend-btn', function(e) {
        e.preventDefault();

        var btn = $(this);

        $.ajax({
            url: btn.attr('href'),
            method: 'DELETE'
        }).done(function(data) {
            $('#friends-dashboard').html(data);
        }).error(function(err) {
            console.log("Accept error:",err);
        });
    });

    $('#invite-form').submit(function(e) {
        e.preventDefault();

        var invite = $(this);

        $.ajax({
            url: invite.attr('action'),
            method: 'POST',
            data: invite.serialize()
        }).done(function(data) {
            $('#friends-dashboard').html(data);
            $('#name').val()
        }).error(function(err) {
            console.log("Invite error:",err);
        });
    });


});