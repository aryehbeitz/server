app.controller('ManagerIndexController', ['$scope','$http', function($scope, $http) {
  $scope.managers = [];
  $scope.city;

  $scope.init = function(managers, countries) {
    $scope.managers = managers;
    $scope.countries = countries;
    //$scope.initCityInput();
  }

  $scope.createManager = function() {
  	$http.post('/staffs.json', {
  		staff: {
  			email: $scope.email,
            entity_type: 'city',
  			entity_id: $scope.city.city_id
  		}
  	}).then(function(response) {
  		var manager = response.data;
  		var i = _.findIndex($scope.managers, { temp_email: manager.temp_email });
  		if (i > -1) {
  			$scope.managers[i] = manager;
  		} else {
  			$scope.managers.push(manager);
  		}
  	});
  }

  $scope.removeCity = function(manager, city) {
    $http.post('/managers/' + manager.id + '/remove_city', {
      city_id: city.id
    }).then(function(response) {
      var manager = response.data;
      var i = _.findIndex($scope.managers, { temp_email: manager.temp_email });
      if (i > -1) {
        $scope.managers[i] = manager;
      }
    });
  }

  $scope.deleteManager = function(manager) {
    var dialog = confirm("בטוח בטוח??");
    if (dialog == true) {
        $http.delete('/staffs/' + manager.id)
        .then(function(response) {
          $scope.managers = _.filter($scope.managers, function(manager) { 
            return manager.id !== response.data.id 
          });
        });
    }
  }

}]);
