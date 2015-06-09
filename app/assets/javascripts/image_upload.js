$(function() {

    // $('.cloudinary-fileupload').bind('fileuploadprogress', function(e, data) {
    //     var progress = Math.round((data.loaded * 100.0) / data.total) + '%'
    //     $('.uk-progress-bar').css('width', progress).text(progress);
    // });

    $('.cloudinary-fileupload').bind('cloudinarydone', function(e, data) {
        $('.preview').html(
            $.cloudinary.image(data.result.public_id, { format: data.result.format, version: data.result.version, crop: 'fill', width: 150, height: 100 })
        );
        // $('.image_public_id').val(data.result.public_id);
        return true;
    });

});