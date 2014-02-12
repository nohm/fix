function Application(config){
  this.name = config.name || "Application";
  this.version = config.version || "1.0";
  this.onError = config.onError || function(){};

  this.controllers = {};
}

Application.prototype = {
  dispatch: function(){
    // Get the current controller and action
    var controller = $("body").data("controller"); 
    var action = $("body").data("action");

    // If the controller and action are defined execute that js
    if(this.controllers.hasOwnProperty(controller)){
      var controller = this.controllers[controller];

      if(controller.hasOwnProperty(action)){
        controller[action]();
        return;
      }
    }
    // Otherwise trigger the specified onError function
    this.onError();
  },

  // Add a controller to the application object
  controller: function(controller){
    this.controllers[controller.name] = controller.actions;
  },

  // Initialize the Application Object
  init: function(){
    // Bind controller dispatch events
    var fn = function(){ window.app.dispatch(); }
    $(document).ready(fn); //full refresh
    $(document).on("page:load", fn); //turbolinks page change
  }
};
