$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e){
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('#edit-answer-' + answerId).removeClass('hidden');
    })

    $('.upvote-answer').on('ajax:success', function (e) {
        var rating = e.detail[0]
        answerId = $(this).data('answerId')
        $('.answer-' + answerId + '-rating-counter').html(rating)
    })
        .on('ajax:error', function(e) {
            var error = e.detail[0]
            $('.alert').html(error)
        })

    $('.downvote-answer').on('ajax:success', function (e) {
        var rating = e.detail[0]
        answerId = $(this).data('answerId')
        $('.answer-' + answerId + '-rating-counter').html(rating)
    })
        .on('ajax:error', function(e) {
            var error = e.detail[0]['error']
            $('.alert').html(error)
        })
});
