//= require lib/utils
app.controller('WitnessAssignController', ['$scope', '$http', '$uibModal',  
  function($scope, $http, $uibModal) {
	$scope.formatBool = formatBool;
	$scope.filter = {};
  $scope.success = false;

  $scope.init = function(witness, countries) {
    $scope.pagination = {
      currentPage: 1
    };

    $scope.witness = witness;
    $scope.countries = countries;

    $scope.$watch('filter', _.throttle(function(oldVal, newVal) {
      if(newVal != oldVal) {
        $scope.filterHosts();
      }
    }, 2000), true);

    // initial call when page loaded (to get initial host list)
    $scope.filterHosts();
  };

    $scope.pageChanged = function() {
      $scope.filterHosts();
    };

  $scope.filterHosts = function() {
  	var params = {};
    params.filter = $scope.filter.query || {};

    if ($scope.filter.special) {
        $scope.filter.special.country ? params.filter.country_id = $scope.filter.special.country.country_numcode: undefined;
        $scope.filter.special.city ? params.filter.country_region_city_id = $scope.filter.special.city.city_id : undefined;
    }

    params.page = $scope.pagination.currentPage;

    $http.get('/salons.json'+ '?' + $.param(params))
    .then(function(response) {
        $scope.salons = response.data.salons;
        //$scope.hosts_count = JSON.parse(response.data.hosts_count);
    });

  }

$scope.assignHost = function(host) {
  var modalInstance = $uibModal.open({
    templateUrl: 'assign-modal.html',
    controller: 'WitnessAssignModalController',
    resolve: {
      host: function () {
        return host;
      },
      witness: function () {
        return $scope.witness;
      }
    }
  });

  modalInstance.result.then(function () {
    $scope.success = true;
  });
}
}]);

app.controller('WitnessAssignModalController', ['$scope', '$http','$uibModalInstance', 'host', 'witness', 
 function($scope, $http, $uibModalInstance, host, witness) {
  
  $scope.host = host;
  $scope.witness = witness;
  $scope.getAccesability = getAccesability;
  $scope.formatDate = formatDate; 
  $scope.formatLanguage = formatLanguage;
  $scope.formatStairs = formatStairs;
  $scope.formatWitnessAvailabilityTime = formatWitnessAvailabilityTime;
  $scope.formatTime = formatTime;
  $scope.formatBool = formatBool;

  $scope.close = function () {
    $uibModalInstance.dismiss('close');
  };

  $scope.createAssignment = function() {
    $scope.error = false;
    
    $http.put('/salons/' + $scope.host.id + '.json', {
      salon: {
          witness_id: $scope.witness.id
      }
    }).then(function(response) {
      if(response.status === 200) {
        window.location = '/' + document.getElementById('locale').className + '/salons/' + host.id;
      } else {
        $scope.error = true;
      }
    });
  }

}]);