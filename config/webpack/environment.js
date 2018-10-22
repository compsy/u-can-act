const { environment } = require('@rails/webpacker')

// Set nested object prop using path notation
// environment.config.set('resolve.extensions', ['.foo', '.bar'])
// environment.config.set('output.filename', '[name].js')

// Delete a property
// environment.config.delete('output.chunkFilename')

// TODO: find a way to load ENV variables for the organization here and find out how they can be referenced from js.
const customConfig = require('./custom')
environment.config.merge(customConfig)

module.exports = environment
