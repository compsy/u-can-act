process.env.NODE_ENV = process.env.NODE_ENV || 'development'
const { merge, webpackConfig } = require('@rails/webpacker')
const environment = require('./environment')

module.exports = merge(environment, webpackConfig)
