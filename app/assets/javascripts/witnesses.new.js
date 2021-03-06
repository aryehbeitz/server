//= require directives/isPhone

app.controller('WitnessNewController', ['$scope','$http','$timeout', function($scope, $http, $timeout) {
    $scope.stepIndex = 0;
    $scope.steps = ['stepOne', 'stepTwo', 'stepThree', 'error'];

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
	$scope.action = 'new';

	// $scope.autocomplete = new google.maps.places.Autocomplete($("#city_name")[0], { types: ['(cities)'] });
	$scope.autocomplete = new google.maps.places.Autocomplete($("#city_name")[0]);
	// $scope.autocomplete.setComponentRestrictions({'country': ['ps', 'il']});
	google.maps.event.addListener($scope.autocomplete, 'place_changed', getAddress);

	$scope.init = function(witness, countries) {
        $scope.countries = countries;

		if(witness.id) {
			delete witness.created_at;
			delete witness.updated_at;
			$scope.witness = witness;
			$scope.action = 'edit';
		}

        if (witness) {
            $scope.witness = witness;
            $scope.user = witness.user;
            $scope.witness.country = $scope.countries.filter(function(country) {return country.country_numcode == $scope.witness.country_region_city.country_numcode})[0];
            $scope.witness.country_region_city = $scope.witness.country.cities.filter(function(city) {return city.city_id == $scope.witness.country_region_city.id})[0];
        }
	}

    $scope.submitStepOne = function() {
        $scope.submitted[0] = true;
        if ($scope.stepOne.$valid) {
            $http.post('/users.json', {
                user: {
                    email: $scope.user.email,
                    phone: $scope.user.phone,
                    full_name: $scope.user.full_name
                }
            }).then(function success(response) {
                $scope.witness.user = response.data.user;
                $scope.stepIndex += 1;
            }).catch(function error(response) {
                if (response.status == 303) {
                    $scope.stepIndex = 3;
                    $scope.errors = {error: "קיים משתמש עם הטלפון או כתובת המייל שהוכנסו", link: response.data.user_url}
                    console.log(response.data.user_url);
                }

            })
        }
    }

	$scope.submit = function() {
		$scope.submitted = true;
		if($scope.form.$valid) {

			submitWitness()
			.then(function(response) {
				if(response.status === 201) {
					window.location = '/' + document.getElementById('locale').className + '/witnesses/' + response.data.id;
				} else {
                    console.log(response.data);
					_.each(response.data, addAlert);
					$("html, body").animate({ scrollTop: 0 }, "slow");
				}
			}).catch(function(response) {
				console.log(response);
				_.each(response.data, addAlert);
				$("html, body").animate({ scrollTop: 0 }, "slow");
			});

		} else {
				$("html, body").animate({ scrollTop: 0 }, "slow");
			}
	}

	$scope.onCityNameBlur = function() {
  	$timeout(function() {
  		if(!$scope.cityFromList) {
  			$scope.witness.city_name = null;
  		}
  		$scope.cityFromList = false;
			$scope.$apply();
  	}, 1000);
  }

	function submitWitness() {
		if($scope.action === 'new') {
			return $http.post('/witnesses.json', {
				witness: $scope.witness
			});
		} else {
			return $http.put('/witnesses/' + $scope.witness.id + '.json', {
				witness: $scope.witness
			});
		}
	}

	$scope.languageChanged = function() {
  	if($scope.witness.language === "other") {
  		$scope.otherLanguageVisible = true;
  		$scope.witness.language = null;
  	}
  }

  function getAddress() {
		$scope.result = $scope.autocomplete.getPlace();
		$scope.cityFromList = true;
		if($scope.result && $scope.result.vicinity.indexOf(',') === -1) {
			$scope.witness.city_name = $scope.result.vicinity;
			// $scope.witness.city_name = getLocalityComponent($scope.result);
		}
		$scope.$apply();
  }

	function getLocalityComponent(result){
	 // Function recieves a google PlacesResult and an array of address components
	 //   and returns the content of that address component
		locality = [];
		address_components = result.address_components;
		for(var i in address_components){
			type = address_components[i].types;
			for(var j in type){
				index = $.inArray(type[j],["locality"]);
				if(type[j] == "locality") {
					locality = address_components[i].long_name;
				}
			}
		}
		return locality;
	}

	function addAlert(alert) {
		$scope.alerts.push({ type: 'danger', msg: alert[0] });
	}

}]);
