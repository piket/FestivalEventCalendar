$(function() {

    console.log('validations loaded')

    $('#login-form').submit(function(e) {

        var email = $(this).children('#user_email');
        var pass = $(this).children('#user_password');

        if (email.match(/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/) === null) {
            e.preventDefault();
        } else if (pass.length < 8) {
            // e.preventDefault();
        }

    });

    $('#form-container').on('submit','#new_user',function(e) {

        console.log('clicked');

        var form_arr = $(this).serializeArray();
        var pass = $('#new_user #user_password').val();
        var valid = true;
        var type = "none"

        for(var i = 2; i < form_arr.length; i++) {
            switch(form_arr[i].name) {
                case "user[name]":
                    if(form_arr[i].value.length < 3){
                        valid = false;
                        type = "name";
                    }
                    break;
                case "user[email]":
                    if(form_arr[i].value.match(/^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/) === null) {
                        valid = false;
                        type = "email";
                    }
                    break;
                case "user[password_confirmation]":
                    if(form_arr[i].value !== pass) {
                        valid = false;
                        type = "pass_confirm " + pass;
                    }
                    break;
                case "user[password]":
                    if(form_arr[i].value.length < 8) {
                        valid = false;
                        if(type !== "pass_confirm") type = "password";
                    }
                    break;
            }
        }

        if (!valid) {
            console.log('invalid',type)
            e.preventDefault();
        }

    });

})