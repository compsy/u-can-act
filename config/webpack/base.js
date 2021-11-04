const { webpackConfig, merge } = require("@rails/webpacker")
const Dotenv = require('dotenv-webpack');

module.exports = merge(webpackConfig, {
  plugins: [new Dotenv({ path: '.env.local', defaults: '.env', silent: true })],
  resolve: {
    extensions: ['.css'],
    alias: {
      jquery: 'jquery/src/jquery'
    }
  }
});
