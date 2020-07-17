import consumer from "../channels/consumer"

$(document).on('turbolinks:load', function () {
    if (window.location.href.match(/questions\/\d+/)) {
        var subscription = consumer.subscriptions.create("AnswersChannel", {
            connected() {
                subscription.perform('follow', gon.params)
            },

            received(data) {
                if (!(gon.user === data.user_id)) {
                    let answerHtml = require('templates/answer.hbs')(data)
                    $('.answers').append(answerHtml)

                    voting()
                }
            }
        })
    }

    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('#edit-answer-' + answerId).removeClass('hidden');
    })

    let voting = function () {
        $('.upvote-answer, .downvote-answer').on('ajax:success', function (e) {
            var rating = e.detail[0]
            var answerId = $(this).data('answerId')
            $('.answer-' + answerId + '-rating-counter').html(rating)
        })


        $('.upvote-answer').on('ajax:error', function (e) {
            var error = e.detail[0]
            $('.alert').html(error)
        })

        $('.downvote-answer').on('ajax:error', function (e) {
            var error = e.detail[0]['error']
            $('.alert').html(error)
        })
    }

    voting()

    $('.answer').on('ajax:success', 'form.new-comment', function (e) {
        let answerId = $(this).data('answerId')
        let commentHtml = require('templates/comment')(e.detail[0])
        $(`#answer-${answerId} .answer-comments-list`).append(commentHtml)
        $(`#answer-${answerId} #comment_body`).val('')
    })

    $('.answer').on('ajax:error', 'form.new-comment', function (e) {
        let answerId = $(this).data('answerId')
        let errors = e.detail[0]
        let errorsSection = $(`#answer-${answerId}`).find('.comment-errors')

        $.each(errors, function (ind, value) {
            errorsSection.html('')
            errorsSection.append(`<p>${value}</p>`)
        })
    })
})
