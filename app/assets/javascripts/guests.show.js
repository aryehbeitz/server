//= require lib/utils
//= require directives/inviteStatus

app.controller('GuestShowController', ['$scope', '$http', function($scope, $http) {
	$scope.formatDate = formatDate;
	$scope.formatAddress = formatAddress;
	$scope.formatLanguage = formatLanguage;
	$scope.getAccesability = getAccesability;
	$scope.formatTime = formatTime;

	$scope.init = function(guest) {
		$scope.guest = guest;
		$scope.invite = guest.user_salon ? guest.user_salon[0] : null;
	}

	$scope.deleteInvite = function(invite) {
		var res = confirm("בטוח בטוח?")
		if(res) {
			$http.delete('/user_salons/' + invite.id + '.json')
					 .then(function(response) {
							if(response.data.success) {
								$scope.invite = null;
							}
				   });	
		}
	}
}]);