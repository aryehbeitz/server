app.controller('StaffNewController', ['$scope','$http', function($scope, $http) {

    $scope.init = function(countries) {
        $scope.countries = countries;
    };

    $scope.createManager = function() {
        console.log("123");
        $http.post('/new_staff.json', {
            user: {
                full_name: $scope.full_name,
                email: $scope.email,
                phone: $scope.phone
            }
        }).then(function(response) {
            $scope.response = response.data
        });
    };

}]);
