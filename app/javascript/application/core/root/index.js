var hot = require('react-hot-loader').hot;

if (process.env.RAILS_ENV === 'production' || process.env.NODE_ENV === 'test') {
  module.exports = require('./prod.js').default
} else {
  module.exports = hot(module)(require('./dev.js').default)
}
