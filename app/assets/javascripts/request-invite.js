//= require guests.new
//= require guests.login
//= require lib/utils

app.controller('RequestInviteController', ['$scope', '$http', '$uibModalInstance', 'host', 'currentUser',
	function($scope, $http, $uibModalInstance, host, currentUser) {
	$scope.view = 'register';
	$scope.host = host;
	$scope.currentUser = currentUser;
	$scope.invite = {
		plusOnes: "0"
	};

	$scope.getAccesability = getAccesability;
	$scope.formatDate = formatDate;
	$scope.formatLanguage = formatLanguage;
	$scope.formatTime = formatTime;
	$scope.formatAddressDisplay = formatAddressDisplay;

	if (!$scope.currentUser)  {
		$scope.view = 'register';
	}
    else {
			$scope.view = 'request';
		}

	$scope.toggleView = function(view) {
		$scope.view = view;
	}

	$scope.close = function (url) {
		if (url) {
			window.location = url;
		} else {
			$uibModalInstance.dismiss('cancel');
		}
  };

  $scope.sendRequest = function() {
  	$http.post('/user_salons', {
        user_salon: {
  			salon_id: $scope.host.id,
            guest_amount: parseInt($scope.invite.plusOnes)+1
  		},
  		locale: document.getElementById('locale').className
  	}).then(function(response) {
  		if(response.data.error) {
  			$scope.view = 'error';
  		} else {
            // after finished with request invite remove it from local storage
            localStorage.removeItem("hostInviteRequested");
            // than change view to success
  			$scope.view = 'success';
  		}
  	});
  }

  $scope.fbShare = function () {
  	FB.ui({
		  method: 'share',
		  href: 'http://www.zikaronbasalon.com/'
		}, function(response){

		});
  };

  $scope.toProfile = function () {
    if ($scope.currentUser.meta_type == "Host") {
      window.location = '/' + document.getElementById('locale').className + '/hosts/' + $scope.currentUser.meta.id;
    }
    else if ($scope.currentUser.meta_type == "Guest") {
    	window.location = '/' + document.getElementById('locale').className + '/guests/' + $scope.currentUser.meta.id;
    }
  }
}])