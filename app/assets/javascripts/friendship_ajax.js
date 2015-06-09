$(function() {

    var btn = null;

    var deleteFriend = function() {
        $.ajax({
                url: btn.attr('href'),
                method: 'DELETE'
            }).done(function(data) {
                $('#friends-dashboard').html(data);
                UIkit.notify('Friend deleted.', {status:'warning'});
            }).error(function(err) {
                console.log("Delete error:",err);
            });
    }

    var declineFriend = function() {
        $.ajax({
            url: btn.attr('href'),
            method: 'DELETE'
        }).done(function(data) {
            $('#friends-dashboard').html(data);
            UIkit.notify('Friend request declined.', {status:'warning'});
        }).error(function(err) {
            console.log("Accept error:",err);
        });
    }

    $('#friends-dashboard').on('click', '.remove-friend-btn', function(e) {
        e.preventDefault();

        btn = $(this);
        var q = "Are you sure you want to remove "+btn.next('.friend-name').text()+" from your friends list?"
        UIkit.modal.confirm(q, deleteFriend);
        $('.js-modal-confirm').text('Yes').next('.uk-modal-close').text('No');
        // if (confirm("Remove "+btn.next('.friend-name').text()+" from your friends.")) {
        //     $.ajax({
        //         url: btn.attr('href'),
        //         method: 'DELETE'
        //     }).done(function(data) {
        //         $('#friends-dashboard').html(data);
        //     }).error(function(err) {
        //         console.log("Delete error:",err);
        //     });
        // }

    });

    $('#friends-dashboard').on('click', '.accept-friend-btn', function(e) {
        e.preventDefault();

        var btn = $(this);

        $.ajax({
            url: btn.attr('href'),
            method: 'PATCH'
        }).done(function(data) {
            $('#friends-dashboard').html(data);
            UIkit.notify('New friend added.', {status:'success'});
        }).error(function(err) {
            UIkit.notify('Unknown error: Please try again.',{status:'danger'});
            console.log("Accept error:",err);
        });
    });

    $('#friends-dashboard').on('click', '.decline-friend-btn', function(e) {
        e.preventDefault();

        btn = $(this);
        UIkit.modal.confirm("Are you sure you want to decline "+btn.next('.friend-name').text()+"'s friend request?",declineFriend);
        $('.js-modal-confirm').text('Yes').next('.uk-modal-close').text('No');

    });

    $('#friends-dashboard').on('submit','#invite-form',function(e) {
        e.preventDefault();

        var invite = $(this);

        $.ajax({
            url: invite.attr('action'),
            method: 'POST',
            data: invite.serialize()
        }).done(function(data) {
            console.log("invite sent")
            $('#friends-dashboard').html(data);
            $('#name').val("")
            UIkit.notify('Invitation sent.',{status:'success'});
        }).error(function(err) {
            $('#name').val("")
            UIkit.notify('No user found.',{status:'danger'});
            console.log("Invite error:",err);
        });
    });


});