requirejs.config({
		baseUrl: "node_modules/",
		nodeRequire: require,
    paths: {
         // specify path relative to `node_modules` folder
         // without .js extension
        jquery: '@bower_components/jquery/dist/jquery',
        jqueryFastLiveFilter: '@bower_components/jquery-fastlivefilter/jquery.fastLiveFilter',
        
        FieldToggleVisibility: '../app/assets/javascripts/modules/FieldToggleVisibility',
        AdviserAjaxCall: '../app/assets/javascripts/modules/AdviserAjaxCall',
        RemoteAndFaceToFaceOptions: '../app/assets/javascripts/modules/RemoteAndFaceToFaceOptions',
        MultiTableFilter: '../app/assets/javascripts/modules/MultiTableFilter',
        ConfirmableForm: '../app/assets/javascripts/modules/ConfirmableForm',
        LanguageSelector: '../app/assets/javascripts/modules/LanguageSelector',
      
        componentLoader: '@bower_components/dough/assets/js/lib/componentLoader',
        utilities: '@bower_components/dough/assets/js/lib/utilities',
        DoughBaseComponent: '@bower_components/dough/assets/js/components/DoughBaseComponent',
        FieldHelpText: '@bower_components/dough/assets/js/components/FieldHelpText',
        
        eventsWithPromises: '@bower_components/eventsWithPromises/src/eventsWithPromises',
        rsvp: '@bower_components/rsvp/rsvp'
    }
});

// If requirejs is present convert the requirejs_config hash to a JSON object
if(window.requirejs) {
	requirejs.config(JSON.stringify(requirejs.config));
}
