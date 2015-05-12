$(function() {

    $('#login-form').submit(function(e) {

        var email = $(this).children('#user_email');
        var pass = $(this).children('#user_password');

        if (email.match(/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/) === null) {
            e.preventDefault();
        } else if (pass.length < 8) {
            // e.preventDefault();
        }

    })

})