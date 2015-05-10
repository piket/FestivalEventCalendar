$(function() {

    $('#friends-dashboard').on('click', '.remove-friend-btn', function(e) {
        e.preventDefault();

        var btn = $(this);

        $.ajax({
            url: btn.attr('href'),
            method: 'DELETE',
            dataType: 'json'
        }).done(function(data) {
            $('#friends-dashboard').html(data);
        }).error(function(err) {
            console.log("Delete error:",err);
            $('#friends-dashboard').html(err.responseText);
        });
    });

    $('#friends-dashboard').on('click', '.accept-friend-btn', function(e) {
        e.preventDefault();

        var btn = $(this);

        $.ajax({
            url: btn.attr('href'),
            method: 'PATCH',
            dataType: 'json'
        }).done(function(data) {
            $('#friends-dashboard').html(data);
        }).error(function(err) {
            console.log("Accept error:",err);
            $('#friends-dashboard').html(err.responseText);
        });
    });

    $('#friends-dashboard').on('click', '.decline-friend-btn', function(e) {
        e.preventDefault();

        var btn = $(this);

        $.ajax({
            url: btn.attr('href'),
            method: 'DELETE',
            dataType: 'json'
        }).done(function(data) {
            $('#friends-dashboard').html(data);
        }).error(function(err) {
            console.log("Accept error:",err);
            $('#friends-dashboard').html(err.responseText);
        });
    });

    $('#invite-form').submit(function(e) {
        e.preventDefault();

        var invite = $(this);

        $.ajax({
            url: invite.attr('action'),
            method: 'POST',
            dataType: 'json',
            data: invite.serialize()
        }).done(function(data) {
            console.log(data);
        }).error(function(err) {
            console.log("Invite error:",err);
            $('#friends-dashboard').html(err.responseText);
        });
    });


});