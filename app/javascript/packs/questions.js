$(document).on('turbolinks:load', function () {
    $('.edit-question').on('click', function (e) {
        e.preventDefault()
        $(this).hide()
        $('.question-edit-form').removeClass('hidden')
    })

    $('.custom-file-input').change(function (e) {
        if (e.target.files.length) {
            $(this).next('.custom-file-label').html(e.target.files[0].name)
        }
    })

    $('#upvote-question, #downvote-question').on('ajax:success', function (e) {
        var rating = e.detail[0]

        $('.question-rating-counter').html(rating)
    })

    $('#upvote-question').on('ajax:error', function (e) {
        var error = e.detail[0]
        $('.alert').html(error)
    })

    $('#downvote-question').on('ajax:error', function (e) {
        var error = e.detail[0]['error']
        $('.alert').html(error)
    })
})