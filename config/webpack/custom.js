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
