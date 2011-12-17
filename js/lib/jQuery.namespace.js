jQuery.namespace = function() {
  var parent = null, ns;
  for (var i = 0; i < arguments.length; i = i + 1) {
    ns = arguments[i].split(".");
    parent = window;
    for (var j = 0; j < ns.length; j = j + 1) {
      parent[ns[j]] = parent[ns[j]] || {};
      parent = parent[ns[j]];
    }
  }
  return parent;
};