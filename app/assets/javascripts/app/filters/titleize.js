angular.module('DeployerApp.filters').filter('titleize', function() {
  return function(input) {
    return _(input).chain().humanize().titleize().value();
  };
});