var Page = {
  body : null,
  init : function (target) {
    this.body = $(target);
  },
  createNewRow : function (event) {
    var row = new RowItem();
    row.appendTo(Page.body);
  }
}
