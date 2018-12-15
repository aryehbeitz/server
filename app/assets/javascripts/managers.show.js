//= require lib/utils
//= require config/constants
//= require directives/managerLink

app.controller('ManagerShowController', ['$scope','$uibModal', '$http', '$location', function($scope, $uibModal, $http, $location) {
    $scope.hosts = [];
    $scope.search = {
        host: {},
        witness: {},
        reverseOrdering: false
    };

    $scope.query = {
        host: null
    };

    $scope.activeView = 'witnesses';
    $scope.formatBool = formatBool;
    $scope.formatDate = formatDate;
    $scope.formatDateTime = formatDateTime;
    $scope.formatWitnessType = formatWitnessType;
    $scope.formatConcept = formatConcept;
    $scope.witnessTypes = witnessTypes;
    $scope.pagination = {
        currentPage: 1
    };

    $scope.sortProp = 'created_at';

    $scope.success = false;
    $scope.loading = false;

    reset_unused_parameters();

    $scope.init = function (currentUser, salons, witnesses, countries, managers, totalHosts, totalWitnesses, currentPage) {
        $scope.currentUser = currentUser;
        $scope.hosts = salons;
        $scope.witnesses = witnesses;
        console.log(witnesses);
        $scope.countries = countries;
        $scope.totalHosts = salons.length;
        $scope.totalWitnesses = totalWitnesses;
        $scope.managers = managers;


        $scope.$watch("search", function (newVal, oldVal) {
            if (newVal != oldVal) {
                filter(1);
            }
        }, true);

        $scope.$watch('query', _.throttle(function (oldVal, newVal) {
            if (newVal != oldVal) {
                filter(1);
            }
        }, 2000), true);
    };

    $scope.editHost = function (host) {
        window.open('/salons/' + host.id, '_blank');
    };

    $scope.editWitness = function (witness) {
        window.open('/witnesses/' + witness.id, '_blank');
    };

    $scope.pageChanged = function () {
        filter($scope.pagination.currentPage);
    };

    function reset_unused_parameters() {
        delete $scope.search.witness.available_day1;
        delete $scope.search.witness.available_day2;
        delete $scope.search.witness.available_day3;
        delete $scope.search.witness.available_day4;
        delete $scope.search.witness.available_day5;
        delete $scope.search.witness.available_day6;
        delete $scope.search.witness.available_day7;

        delete $scope.search.witness.external_assignment;
        delete $scope.search.witness.archived;
        delete $scope.search.witness.need_to_followup;
        delete $scope.search.has_host;
    }

    function filter(page) {
        $scope.loading = true;
        reset_unused_parameters();
        if (typeof $scope.search.available_day_search !== 'undefined' && $scope.search.available_day_search != null) {
            $scope.search.witness[$scope.search.available_day_search] = true;
        }

        if ($scope.search.w_has_host == true) {
            $scope.search.has_host = $scope.search.w_has_host;
        }
        else if ($scope.search.w_has_host == false) {
            $scope.search.has_host = $scope.search.w_has_host;
            $scope.search.witness.external_assignment = false;
            $scope.search.witness.archived = false;
            $scope.search.witness.need_to_followup = false;

        }
        else if ($scope.search.w_has_host == -1) {
            // when selecting external_assignment, all other options should be false
            $scope.search.witness.external_assignment = true;
        }
        else if ($scope.search.w_has_host == -2) {
            // when selecting archived, all other options should be false
            $scope.search.witness.archived = true;
        }
        else if ($scope.search.w_has_host == -3) {
            // when selecting need_to_followup, all other options should be false
            $scope.search.witness.need_to_followup = true;
        }

        var params = {
            filter: {
                host: getFilterKeys($scope.search.host),
                witness: getFilterKeys($scope.search.witness),
                required_salon: $scope.search.required_salon,
                required_witness_year: $scope.search.required_witness_year,
                direct_manager: $scope.search.direct_manager
            },
            page: page,
            reverse_ordering: +$scope.search.reverseOrdering,
            host_query: $scope.query.host,
            witness_query: $scope.query.witness,
            host_sort: $scope.sortProp,
            witness_sort: $scope.witnessSortProp,
            has_manager: $scope.search.has_manager,
            has_survivor: $scope.search.has_survivor,
            is_red: $scope.search.is_red,
            is_org: $scope.search.is_org,
            in_future: $scope.search.in_future,
            has_invites: $scope.search.has_invites
        };

        if ($scope.search.witness_year) {
            params['filter']['witness_year'] = {};
            params['filter']['witness_year'][$scope.search.witness_year.available_day_search] = true;
        }


        $http.get('/staffs/' + $scope.currentUser.id + '.json' + '?' + $.param(params))
            .then(
                function (response) {
                    //$scope.salons = JSON.parse(response.data.salons);
                    $scope.witnesses = response.data.witnesses;
                    //$scope.pagination.currentPage = response.data.page;
                    //$scope.totalHosts = response.data.total_hosts;
                    $scope.totalWitnesses = response.data.total_witnesses;
                    $scope.loading = false;
                })
            .catch(
                function (e) {
                    $scope.loading = false;
                    alert(e.message);
                });
    }

    $scope.export_hosts = function () {
        var params = {
            filter: {
                host: getFilterKeys($scope.search.host)
            },
            host_query: $scope.query.host,
            host_sort: $scope.sortProp,
            has_manager: $scope.search.has_manager,
            has_host: $scope.search.has_host,
            has_survivor: $scope.search.has_survivor,
            is_red: $scope.search.is_red,
            is_org: $scope.search.is_org,
            event_language: $scope.search.event_language,
            in_future: $scope.search.in_future,
            has_invites: $scope.search.has_invites
        };

        window.open(
            '/managers/' + $scope.currentUser.meta.id + '/export_hosts' + '?' + $.param(params),
            '_blank' // <- This is what makes it open in a new window.
        );
    };

    $scope.export_witnesses = function () {
        var params = {
            filter: {
                witness: getFilterKeys($scope.search.witness)
            },
            witness_query: $scope.query.witness,
            witness_sort: $scope.witnessSortProp,
            has_manager: $scope.search.has_manager,
            has_host: $scope.search.has_host,
            event_language: $scope.search.event_language,
        };

        window.open(
            '/managers/' + $scope.currentUser.meta.id + '/export_witnesses' + '?' + $.param(params),
            '_blank' // <- This is what makes it open in a new window.
        );
    };

    $scope.export_guests = function () {
        window.open(
            '/managers/' + $scope.currentUser.meta.id + '/export_guests',
            '_blank' // <- This is what makes it open in a new window.
        );
    };

    function getFilterKeys(filterObj) {
        var filtered = {};
        _.mapKeys(filterObj, function (value, key) {
            if (!_.isNull(value) && value !== "") {
                filtered[key] = value;
            }
        });
        delete filtered.query;
        return filtered;
    }

    $scope.sort = function (arr) {
        //return _.sortBy(arr, $scope.sortProp).reverse();
    };

    $scope.isAccesible = function (host) {
        return host.floor === 0 || host.elevator;
    };

    $scope.onViewToggle = function (view) {
        $scope.activeView = view;
    };

    $scope.setSortProp = function (prop) {
        $scope.search.reverseOrdering = !$scope.search.reverseOrdering;
        $scope.sortProp = prop;
        filter(1);
    };

    $scope.setSortPropWitness = function (prop) {
        $scope.search.reverseOrdering = !$scope.search.reverseOrdering;
        $scope.witnessSortProp = prop;
        filter(1);
    };

    $scope.getManager = function (obj) {
        return obj.city && obj.city.managers ? obj.city.managers[0] : {};
    };

    $scope.deleteHost = function (host) {
        var confirmMessage = !!host.witness ? 'למארח יש ציוות. ' : '';
        confirmMessage += 'בטוח בטוח?';
        var res = confirm(confirmMessage);
        if (res) {
            $http.delete('/hosts/' + host.id + '.json').then(function (response) {
                if (response.data.success) {
                    $scope.showSuccessMessage();
                    $scope.success = true;
                    $scope.hosts = _.filter($scope.hosts, function (host) {
                        return host.id !== response.data.host.id;
                    });
                }
            });
        }
        ;
    };

    $scope.deleteWitness = function (witness) {
        var res = confirm("בטוח בטוח?");
        if (res) {
            $http.delete('/witnesses/' + witness.id + '.json').then(function (response) {
                if (response.data.success) {
                    $scope.showSuccessMessage();
                    $scope.witnesses = _.filter($scope.witnesses, function (witness) {
                        return witness.id !== response.data.witness.id;
                    });
                }
            });
        }
    };

    $scope.deleteManager = function (manager) {
        var res = confirm("בטוח בטוח?");
        if (res) {
            $http.delete('/' + document.getElementById('locale').className + '/'+ document.getElementById('year').className + '/staffs/' + manager.id + '.json').then(function (response) {
                if (response.data.success) {
                    $scope.showSuccessMessage();
                }
            });
        }
    };

    $scope.showSuccessMessage = function () {
        $scope.success = true;
        setTimeout(function () {
            $scope.success = false;
            $scope.$apply();
        }, 3000);
    };

    function activeFilter(filter) {
        return !_.isUndefined(filter) && !_.isNull(filter);
    }

    $scope.contactWitnessDue = function (host) {
        return host.has_witness && !host.contacted_witness &&
            ((new Date() - new Date(host.assignment_time)) / (1000 * 60 * 60 * 24)) > 2
    };

    $scope.addManager = function (witness) {
        var modalInstance = $uibModal.open({
            templateUrl: 'add_manager_to_entity.html',
            controller: 'AddManagerToWitnessModal',
            backdrop: false,
            resolve: {
                witness: function () {
                    return witness;
                },
                managers: function () {
                    return $scope.managers
                }
            }
        });

        modalInstance.result.then(function (manager) {
            $http.post('/' + document.getElementById('locale').className + '/'+ document.getElementById('year').className + '/staffs.json', {
                staff: {
                    user_id: manager.user_id,
                    entity_type: 'witness',
                    entity_id: witness.id

                }
            }).then(function (response) {
            }, function () {
                alert('error');
            });
        });
    }

}]);

app.controller('AddManagerToWitnessModal', function($scope, $uibModalInstance, witness, managers){
    $scope.witness = witness;
    $scope.managers = managers;

    $scope.select = function(manager) {
        $uibModalInstance.close(manager);
    }

    $scope.cancel = function() {
        $uibModalInstance.dismiss('cancel');
    }

})