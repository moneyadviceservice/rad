//= require require_config.js

// Components
require(['jquery', 'componentLoader', 'eventsWithPromises'], function ($, componentLoader, eventsWithPromises) {
  componentLoader.init($('body'));
});

require(['jquery'], function ($) {
  require(['AdviserAjaxCall']);
  require(['RemoteAndFaceToFaceOptions']);
});
