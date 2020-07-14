const {environment} = require('@rails/webpacker')
const handlebars = require('./loaders/handlebars')

environment.loaders.prepend('handlebars', handlebars)

const webpack = require('webpack')
environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    jquery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default']
}))

module.exports = environment