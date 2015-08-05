//= require require_config.js.erb

// Components
require(['jquery', 'componentLoader', 'eventsWithPromises'], function ($, componentLoader, eventsWithPromises) {
  componentLoader.init($('body'));
});

require(['jquery'], function ($) {
  require(['AdviserAjaxCall']);
  require(['RemoteAndFaceToFaceOptions']);
});
