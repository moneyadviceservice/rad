//= require require_config.js

// Components
require(['jquery', 'componentLoader'], function ($, componentLoader) {
  componentLoader.init($('body'));
});

require(['jquery'], function ($) {
  require(['AdviserAjaxCall']);
  require(['RemoteAndFaceToFaceOptions']);
});
