/**
 * Entry point to handle dynamically determining the webpack url for assets
 * in production
 */

var html = typeof document !== 'undefined' ? document.querySelector('html') : "";
var baseUrl = html && html.dataset.baseuri || '';

__webpack_public_path__ = `${baseUrl}/packs/`
