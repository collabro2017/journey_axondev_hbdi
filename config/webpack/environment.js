const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const merge = require('webpack-merge')

const cssLoaderOptions = {
  modules: true,
  sourceMap: true,
  localIdentName: '[path]__[local]___[hash:base64:5]'
}

const CSSLoader = environment.loaders.get('css').use.find(el => el.loader === 'css-loader')

CSSLoader.options = merge(CSSLoader.options, cssLoaderOptions)

environment.plugins.prepend(
  'Define',
  new webpack.DefinePlugin({
    'process.env': {
      'RAILS_ENV': '"' + process.env.RAILS_ENV + '"'
    }
  })
)

module.exports = environment
