const { environment } = require('@rails/webpacker')
const Dotenv = require('dotenv-webpack');

environment.plugins.prepend('Dotenv', new Dotenv({ path: '.env.local', defaults: '.env' }))

module.exports = environment
