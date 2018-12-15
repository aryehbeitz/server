app.controller('UserSigninController', ['$scope', '$http', '$uibModal', 'activeUsers', function($scope, $http, $uibModal, activeUsers) {
	$scope.form = {};
	$scope.error = false;

	$scope.submit = function(event) {
		$scope.error = false;

		$scope.locale = document.getElementById('locale').className;
		event.preventDefault();
		if ($scope.signinForm.$valid) {
			$http.post('sign_in.json', {
				user: {
					email: $scope.form.email,
					password: $scope.form.password,
				}
			}).then(function(response) {
				if(response.status === 201) {
					activeUsers.assignActiveUser(response.data);
					return;
				}
			}).catch(function(response) {
				if(response.status > 400) {
					$scope.error = true;
				}
			});
		}
	}
}]);

