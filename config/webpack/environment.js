const { environment } = require('@rails/webpacker')
const customConfig = require('./custom')

// Set nested object prop using path notation
// environment.config.set('resolve.extensions', ['.foo', '.bar'])
// environment.config.set('output.filename', '[name].js')

// Merge custom config
environment.config.merge(customConfig)

// Delete a property
// environment.config.delete('output.chunkFilename')

module.exports = environment
