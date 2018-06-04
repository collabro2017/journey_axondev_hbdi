/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// Required to ensure the __webpack_public_path__ variable is set
if (process.env.RAILS_ENV === 'production') {
  module.exports = require('../application/webpack.path.js').default
} 

var init = require('../application/core').init


document.addEventListener('DOMContentLoaded', () => {  
  const html =  document.querySelector('html')
  const baseUrl = html.dataset.baseuri || '';

  init({base: baseUrl})
})

if(module.hot){
  module.hot.accept('../application/core', ()=>{
    require('../application/core').init(opts)
  })
}