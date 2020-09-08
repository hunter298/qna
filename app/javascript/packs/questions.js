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

    $('.question-comments').on('ajax:success', 'form.new-comment', function (e) {
        let commentHtml = require('templates/comment')(e.detail[0])
        $('.question-comments-list').append(commentHtml)
        $('.question-comments #comment_body').val('')
    })

    $('.question-comments').on('ajax:error', 'form.new-comment', function (e) {
        let errors = e.detail[0]
        let errorSection = $('.question-comments .comment-errors')

        $.each(errors, function (ind, value) {
            errorSection.html('')
            errorSection.append(`<p>${value}</p>`)
        })
    })

    $('#subscribe-for-answers').on('click', function (e) {
        e.preventDefault()
        $(this).addClass('hidden')
        $('#unsubscribe-from-answers').removeClass('hidden')
    })
})