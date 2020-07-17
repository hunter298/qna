import consumer from "../channels/consumer"

$(document).on('turbolinks:load', function () {
    if (window.location.href.match(/questions\/\d+/)) {
        var subscription = consumer.subscriptions.create("CommentsChannel", {
            connected() {
                subscription.perform('follow', gon.params)
            },

            received(data) {
                if (!(gon.user === data.user.id)) {
                    let commentHtml = require('templates/comment.hbs')(data)
                    $(`.${data.comment.commentable_type.toLowerCase()}-comments-list`).append(commentHtml)
                }
            }
        })
    }
})