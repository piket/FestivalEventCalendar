$(function() {

    console.log('validations loaded')

    $('#login-form').submit(function(e) {
        e.preventDefault();

        var email = $('#user_email').val();
        var pass = $('#user_password').val();

        if (email.match(/(.+)@(.+){2,}\.(.+){2,}/) === null) {
            $('.error-msg').text("Invalid email");
        } else if (pass.length < 6) {
            $('.error-msg').text("Invalid password")
        } else {
            var form = $(this)

            $.ajax({
                url: form.attr('action'),
                method: 'POST',
                data: form.serialize(),
                dataType: 'json'
            }).done(function(data) {
                form.trigger('reset');
                if (data.result) {
                    window.location.href = '/';
                } else {
                    $('.error-msg').text(data.msg);
                }
            }).error(function(err) {
                console.log(err);
            });
        }

    });

    $('#form-container').on('submit','#new_user',function(e) {

        console.log('clicked');

        $('.invalid-label').hide();

        var form_arr = $(this).serializeArray();
        var pass = $('#new_user #user_password').val();
        var valid = true;
        var type = []

        for(var i = 2; i < form_arr.length; i++) {
            switch(form_arr[i].name) {
                case "user[name]":
                    if(form_arr[i].value.length < 3){
                        valid = false;
                        type.push($('.name-invalid'))
                    }
                    break;
                case "user[email]":
                    if(form_arr[i].value.match(/(.+)@(.+){2,}\.(.+){2,}/) === null) {
                        valid = false;
                        type.push($('.email-invalid'))
                    }
                    break;
                case "user[password_confirmation]":
                    if(form_arr[i].value !== pass || pass === "") {
                        valid = false;
                        type.push($('.pass-confirm-invalid'))
                    }
                    break;
                case "user[password]":
                    if(form_arr[i].value.length < 6) {
                        valid = false;
                        if(type !== "pass_confirm") type.push($('.password-invalid'))
                    }
                    break;
            }
        }

        if (!valid) {
            console.log('invalid',type)
            type.forEach(function(t) {
                t.show();
            })
            e.preventDefault();
        }

    });

})