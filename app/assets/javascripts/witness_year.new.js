//= require directives/isPhone

app.controller('WitnessYearNewController', ['$scope','$http','$timeout', function($scope, $http, $timeout) {

    window.onbeforeunload= function(e) {
        if (true) {
            e.preventDefault();
            e.returnValue = "Are you sure you want to navigate away from this page"
            return "Are you sure you want to navigate away from this page"
        }
    };

	$scope.witness = {
		can_morning: true,
		can_afternoon: true,
		can_evening: true,
		free_on_day: true,
		special_population: false,
    available_day1: false,
    available_day2: false,
    available_day3: false,
    available_day4: false,
    available_day5: false,
    available_day6: false,
    available_day7: false
	};

	$scope.otherLanguageVisible = false;

	$scope.typeOptions = [
		{ n: 'ניצול', v: 'survivor' }, 
		{ n: 'אקדמיה', v: 'academia' },
		{ n: 'דור שני', v: 'second_generation' },
		{ n: 'מטפל', v: 'therapist' }
	];

	$scope.submitted = false;
	$scope.alerts = [];

	$scope.init = function(witness, countries, witness_year) {
        $scope.countries = countries;
        $scope.witness = witness;

        $scope.witness_year = witness_year || {};

        $scope.user = witness.user;
        if ($scope.witness.country_region_city) {
            $scope.country = $scope.countries.filter(function(country) {return country.country_numcode == $scope.witness.country_region_city.country_numcode})[0];
            $scope.witness.country_region_city = $scope.witness.country.cities.filter(function(city) {return city.city_id == $scope.witness.country_region_city.id})[0];
        }
	}

	$scope.submit = function() {
		$scope.submitted = true;
		if($scope.form.$valid) {
            var url;

            $scope.witness_year.id ? url = $scope.witness_year.id + '.json' :  url = 'witness_years.json';
            $http.post(url, {
                witness_year:$scope.witness_year,
                witness:$scope.witness,
                call_details: $scope.call_details
                })
			.then(function(response) {
				if(response.status === 201) {
					window.location = '/' + document.getElementById('locale').className + '/staffs/current';
				} else {
                    console.log(response.data);
					//_.each(response.data, addAlert);
					//$("html, body").animate({ scrollTop: 0 }, "slow");
				}
			}).catch(function(response) {
				console.log(response);
				//_.each(response.data, addAlert);
				//$("html, body").animate({ scrollTop: 0 }, "slow");
			});
		
		} else {
				$("html, body").animate({ scrollTop: 0 }, "slow");
			}
	}

	$scope.languageChanged = function() {
  	if($scope.witness.language === "other") {
  		$scope.otherLanguageVisible = true;
  		$scope.witness.language = null;
  	}
  }

	function addAlert(alert) {
		$scope.alerts.push({ type: 'danger', msg: alert[0] });
	}

}]);
