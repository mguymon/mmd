describe('Home Controllers', function() {
  beforeEach(module('DeployerApp.home', 'DeployerApp.services'));

  describe('HomeCtrl', function(){
    var scope, ctrl, $httpBackend, router;

    beforeEach(inject(function(_$httpBackend_, $route, $rootScope, $controller) {
      scope = $rootScope.$new();

      router = $route;

      ctrl = $controller("HomeCtrl", {$scope: scope});
    }));

    it("should have a / route", function() {
      expect(router.routes['/']).toBeDefined();
      expect(router.routes['/'].controller).toEqual("HomeCtrl");
    });

    it("should have a /home route", function() {
      expect(router.routes['/home']).toBeDefined();
      expect(router.routes['/home'].controller).toEqual("HomeCtrl");
    });
  });
});