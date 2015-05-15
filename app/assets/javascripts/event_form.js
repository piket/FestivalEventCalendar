$(function() {

    var count = 0

    var generateRow = function(classMod) {
        var dateFormat = 'MM.DD.YYYY'
        var timeFormat = '12h'

        var locationRow = '<div class="occurrence-block'+classMod+'" id="'+count+'"><div class="uk-form-row"><div class="uk-form-controls"><label>LOCATION</label><input type="text" name="event[location]['+count+']" placeholder="Enter event location" id="event_location_'+count+'"><button class="uk-button uk-button-danger uk-button-mini" id="remove-'+count+'">Delete</button></div></div>';
        var dateTimeRow = '<div class="uk-form-row"><div class="uk-form-controls"><i class="uk-icon-calendar"></i><input type="" data-uk-datepicker="{format:\''+dateFormat+'\'}" placeholder = "Select a date." name="event[date]['+count+']"><i class="uk-icon-clock-o"></i><input type="text" data-uk-timepicker="{format: \''+timeFormat+'\'}" placeholder = "Select a time." name="event[time]['+count+']"></div></div></div>';
        var multiDiv = $('div#multiple');

        multiDiv.append(locationRow+dateTimeRow);
        // multiDiv.append(dateTimeRow);
        $('#remove-'+count).click(function(e) {
            e.preventDefault();
            var div = $(this).parent().parent().parent();
            var id = div.attr('id')
            div.children().remove();
            div.append('<input type="hidden" value="'+id+'" name="event[deleted]['+id+']">');
        });
        count++;
    }

    var cleanTag = function(tag) {
        tag = tag.toLowerCase()
        console.log(tag);
        // tag.text(tag.text().toLowerCase())
        // return tag.toLowerCase();
    }

    console.log('Page loaded');

    $('#tags').tagsInput({
        // 'width': '100px',
        // 'delimiter': ',',
        // 'onAddTag': cleanTag
    });

    if ($(":radio").eq(1).attr('checked')) {
        $('#add-occurrence').hide();
    }

    if ($('#new_event').is('form')) {
        generateRow('-first');
        $('#remove-0').remove()
    } else if ($('.edit_event').is('form')) {
        console.log("Edit page loaded")

        $('.uk-button-danger').each(function(i,btn) {
            $(btn).click(function(e) {
                e.preventDefault();
                var div = $(this).parent().parent().parent();
                var id = div.attr('id')
                div.children().remove();
                div.append('<input type="hidden" value="'+id+'" name="event[deleted]['+id+']"><input type="hidden" name="event[date]['+id+']">');
            });
        });
        count = parseInt($('.occurrence-block, .occurrence-block-first').last().attr('id')) + 1;
    }

    $("input[name='multiple']:radio").on('change',function(){
        var rowDivs = $('div#multiple>div.occurrence-block');

        if ($(this).val() == 'true') {
            rowDivs.show();
            $('#add-occurrence').show();
            // generateRow("");
        } else {
            rowDivs.hide();
            $('#add-occurrence').hide();
        }
    });

    $('#add-occurrence').click(function(e) {
        e.preventDefault();
        generateRow('');
    });



});