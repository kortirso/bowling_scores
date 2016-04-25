$(function() {
    var nestedStep;
    nestedStep = $('.alleys').last();
    $('.duplicate_player').click(function(e) {
        var formsOnPage, lastNestedForm, newNestedForm;
        e.preventDefault();
        lastNestedForm = $('.alleys').last();
        newNestedForm = $(nestedStep).clone();
        formsOnPage = $(lastNestedForm).data("alleys") + 1;
        $(newNestedForm).attr("data-alleys", formsOnPage);
        $(newNestedForm).find('input').each(function() {
            var newId, newName, oldId, oldName;
            oldId = $(this).attr('id');
            newId = oldId.replace(new RegExp(/_[0-9]+_/), "_" + formsOnPage + "_");
            $(this).attr('id', newId);
            oldName = $(this).attr('name');
            newName = oldName.replace(new RegExp(/\[[0-9]+\]/), "[" + formsOnPage + "]");
            $(this).attr('name', newName);
            $(this).val('');
        });
        $(newNestedForm).insertAfter(lastNestedForm);
    });
    $('#new_game_alleys').on('click', '.remove_player', function(e) {
        e.preventDefault();
        if($('.alleys').length > 2) {
            $(this).parent('p').parent('.col-xs-1').parent('.alleys').remove();
        }
    });
});