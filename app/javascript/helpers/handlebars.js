const Handlebars = require('handlebars/runtime')

Handlebars.registerHelper('delete_link', function (object_user_id, subject, id) {
    if (object_user_id === gon.user) {
        return new Handlebars.SafeString(`
            <a class="text-danger" rel="nofollow" data-method="delete" href="${subject}${id}">Delete</a>`
        )
    }
})

Handlebars.registerHelper('author_of?', function (object_user_id) {
    return (object_user_id === gon.user)
})