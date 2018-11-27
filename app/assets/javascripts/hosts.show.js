//= require lib/utils
//= require directives/commentForm
//= require directives/commentList

app.controller('SalonShowController', ['$scope', '$http', function($scope, $http) {
    $scope.formatDateTime = formatDateTime;
    $scope.formatDate = formatDate;
    $scope.formatTime = formatTime;
    $scope.getAccesability = getAccesability;
    $scope.formatStrangers = formatStrangers;
    $scope.formatBool = formatBool;

    $scope.init = function(salon) {
        $scope.salon = salon;
        $scope.comments = salon.comments;
        $scope.invites = salon.user_salon;
        $scope.host = salon.user;

        if($scope.invites && $scope.invites > 0) {
            initInvites($scope.invites);
        }

        //as long as the host didn't finish filling out his details, take him to edit page
        if ($scope.host.active == false) {
            if (confirm("some details are missing. press ok to fill them in")) {
                window.location = '/' + document.getElementById('locale').className + '/hosts/' + $scope.host.id + '/edit';
            }
        }
    }


    $scope.copyRegisterLink = function() {
        var el = document.getElementById("register-link-input");
        if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
            var editable = el.contentEditable;
            var readOnly = el.readOnly;
            el.contentEditable = true;
            el.readOnly = false;
            var range = document.createRange();
            range.selectNodeContents(el);
            var sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(range);
            el.setSelectionRange(0, 999999);
            el.contentEditable = editable;
            el.readOnly = readOnly;
        }
        else {
            // Solution for android and browser, selects the input and focuses on it so that content can be copied
            el.focus();
            el.select();
        }

        document.execCommand('copy');

        /* Alert the copied text */
        alert("Copied the text: " + el.value);
    };

    $scope.deactivateHost = function() {
        var confirmed=confirm("בטוח בטוח?");
        if (!confirmed) return;
        $scope.success = false;
        $http.put('/hosts/' + $scope.host.id + '.json', {
            deactivate: true
        }).then(function success(response) {
            $scope.success = true;
            window.location.reload();
        })
    }

    $scope.save = function(salon) {
        $scope.success = false;
        $http.put('/salons/' + salon.id + '.json', {
            salon: {
                concept: salon.concept,
                contacted: salon.contacted,
                preparation_evening: salon.preparation_evening,
                contacted_witness: salon.contacted_witness,
                strangers: salon.strangers,
                max_guests: salon.max_guests
            }
        }).then(function success(response) {
            $scope.success = true;
        })
    }

    $scope.commentCallback = function(response) {
        $scope.comments.push(response.data);
    }

    $scope.updateInvite = function(invite, confirmedStatus) {
        var res = confirmedStatus ? true : confirm("האם אתה בטוח שאתה רוצה לבטל את בקשת ההתארחות?");
        if (res) {
            $http.put('/user_salons/' + invite.id + '.json', {
                user_salon: {
                    approved: confirmedStatus
                }
            }).then(function success(response) {
                initInvites(response.data);
            })
        }
    }

    $scope.closeEvening = function(salon) {
        salon.strangers = false;
        $scope.save(salon);
    }

    // $scope.fbShare = function () {
    // 	var base = window.location.origin;
    // 	var link = base + '/' + document.getElementById('locale').className + '/pages/home/'  + '?invite=' + $scope.host.id;

    // 	console.log(link);

    // 	FB.ui({
    // 	  method: 'share',
    // 	  href: link
    // 	}, function(response){

    // 	});
    // };


    // $scope.fbShare = function () {
    // 	var base = window.location.origin;
    // 	var link = encodeURIComponent(base + '/' + document.getElementById('locale').className + '/pages/home/'  + '?invite=' + $scope.host.id);
    // 	window.open(
    // 	  'https://www.facebook.com/dialog/share?app_id=1425545090852355&display=popup&href=' + link,
    // 	  '_blank' // <- This is what makes it open in a new window.
    // 	);
    //  	};


    $scope.fbShare = function () {
        FB.ui({
            method: 'share',
            href: 'http://zikaronbasalon.herokuapp.com/' + document.getElementById('locale').className + '/pages/home/'  + '?invite=' + host.id
        }, function(response){
        });
    };

    function initInvites(invites) {
        var invites = _.groupBy(invites, 'confirmed');
        $scope.pendingInvites = invites[false];
        $scope.confirmedInvites = invites[true];
    }
}]);

app.controller('HostShowController', ['$scope', '$http', function($scope, $http) {
    $scope.formatDateTime = formatDateTime;
    $scope.formatDate = formatDate;
    $scope.formatTime = formatTime;
    $scope.getAccesability = getAccesability;
    $scope.formatStrangers = formatStrangers;
    $scope.formatBool = formatBool;

    $scope.init = function(user) {
        $scope.host = user;
        $scope.comments = user.comments;
        $scope.host.invites = user.salon.user_salon;
        $scope.salons = user.salon;

        if(user.invites && host.invites.length > 0) {
            initInvites(host.invites);
        }

        //as long as the host didn't finish filling out his details, take him to edit page
        if ($scope.host.active == false) {
            if (confirm("some details are missing. press ok to fill them in")) {
                window.location = '/' + document.getElementById('locale').className + '/hosts/' + $scope.host.id + '/edit';
            }
        }
    }


    $scope.copyRegisterLink = function() {
        var el = document.getElementById("register-link-input");
        if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
            var editable = el.contentEditable;
            var readOnly = el.readOnly;
            el.contentEditable = true;
            el.readOnly = false;
            var range = document.createRange();
            range.selectNodeContents(el);
            var sel = window.getSelection();
            sel.removeAllRanges();
            sel.addRange(range);
            el.setSelectionRange(0, 999999);
            el.contentEditable = editable;
            el.readOnly = readOnly;
        }
        else {
            // Solution for android and browser, selects the input and focuses on it so that content can be copied
            el.focus();
            el.select();
        }

        document.execCommand('copy');

        /* Alert the copied text */
        alert("Copied the text: " + el.value);
    };

    $scope.deactivateHost = function() {
        var confirmed=confirm("בטוח בטוח?");
        if (!confirmed) return;
        $scope.success = false;
        $http.put('/hosts/' + $scope.host.id + '.json', {
            deactivate: true
        }).then(function success(response) {
            $scope.success = true;
            window.location.reload();
        })
    }

    $scope.save = function(salon) {
        $scope.success = false;
        $http.put('/salons/' + salon.id + '.json', {
            salon: {
                concept: salon.concept,
                contacted: salon.contacted,
                preparation_evening: salon.preparation_evening,
                contacted_witness: salon.contacted_witness,
                strangers: salon.strangers,
                max_guests: salon.max_guests
            }
        }).then(function success(response) {
            $scope.success = true;
        })
    }

    $scope.commentCallback = function(response) {
        $scope.comments.push(response.data);
    }

    $scope.updateInvite = function(invite, confirmedStatus) {
        var res = confirmedStatus ? true : confirm("האם אתה בטוח שאתה רוצה לבטל את בקשת ההתארחות?");
        if (res) {
            $http.put('/user_salons/' + invite.id + '.json', {
                user_salon: {
                    approved: confirmedStatus
                }
            }).then(function success(response) {
                initInvites(response.data);
            })
        }
    }

    $scope.closeEvening = function(salon) {
        salon.strangers = false;
        $scope.save(salon);
    }

    // $scope.fbShare = function () {
    // 	var base = window.location.origin;
    // 	var link = base + '/' + document.getElementById('locale').className + '/pages/home/'  + '?invite=' + $scope.host.id;

    // 	console.log(link);

    // 	FB.ui({
    // 	  method: 'share',
    // 	  href: link
    // 	}, function(response){

    // 	});
    // };


    // $scope.fbShare = function () {
    // 	var base = window.location.origin;
    // 	var link = encodeURIComponent(base + '/' + document.getElementById('locale').className + '/pages/home/'  + '?invite=' + $scope.host.id);
    // 	window.open(
    // 	  'https://www.facebook.com/dialog/share?app_id=1425545090852355&display=popup&href=' + link,
    // 	  '_blank' // <- This is what makes it open in a new window.
    // 	);
    //  	};


    $scope.fbShare = function () {
        FB.ui({
            method: 'share',
            href: 'http://zikaronbasalon.herokuapp.com/' + document.getElementById('locale').className + '/pages/home/'  + '?invite=' + host.id
        }, function(response){
        });
    };

    function initInvites(invites) {
        var invites = _.groupBy(invites, 'confirmed');
        $scope.pendingInvites = invites[false];
        $scope.confirmedInvites = invites[true];
    }
}]);