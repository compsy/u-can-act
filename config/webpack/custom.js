// NOTE: no longer used? Does jquery still work?
module.exports = {
  resolve: {
    alias: {
      jquery: 'jquery/src/jquery'
    }
  },
  optimization: {
    splitChunks: {
      chunks: 'all'
    }
  }
}
