jQuery.namespace('com.meathill.bacon');
com.meathill.bacon.PageSettings = Backbone.View.extend({
  originTitle: '',
  events: {
    "keyup #page-title": "onEdit"
  },
  initialize: function () {
    this.originTitle = $('title').text();
    this.setElement($('#' + this.attributes.id));
  },
  onEdit: function (event) {
    if (event.target.value != '') {
      $('title').text(this.originTitle + ' : ' + event.target.value);
    } else {
      $('title').text(this.originTitle);
    }
  }
});
