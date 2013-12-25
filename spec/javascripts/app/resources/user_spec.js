describe('User Resources', function() {
  beforeEach(module('DeployerApp.users'));

  var user_response = { 
    id: 1, display_name: 'Test Testerson', email: 'test@test.com'
  }; 

  describe('User', function(){
    var scope, resource, $httpBackend;

    beforeEach(inject(function(_$httpBackend_, $rootScope, User) {
      $httpBackend = _$httpBackend_;
      $httpBackend.expectGET('/users/1.json').
        respond(user_response);

      scope = $rootScope.$new();
      resource = User
    }));

    it('should show user', function() {
      result = resource.show({user_id: 1});
      $httpBackend.flush();

      expect(result.email).toEqual(user_response.email);
    });
  });
});