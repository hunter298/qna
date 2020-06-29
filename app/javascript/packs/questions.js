$(document).on('turbolinks:load', function() {
    $('.edit-question').on('click', function(e) {
        e.preventDefault()
        $(this).hide()
        $('.question-edit-form').removeClass('hidden')
    })

    $('.custom-file-input').change(function (e) {
        if (e.target.files.length) {
            $(this).next('.custom-file-label').html(e.target.files[0].name)
        }
    })
})