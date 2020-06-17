$(document).on('turbolinks:load', function() {
    $('.edit-question').on('click', function(e) {
        e.preventDefault()
        $(this).hide()
        $('.question-edit-form').removeClass('hidden')
    })
})