app.directive('commentForm', function () {
  return {
  	scope: { 
      resource: '@',
      entityId: '@',
      callback: '='
  	},
  	controller: ['$http', function($http) {
      var self = this;
      this.text = '';
  		this.submit = function() {
        $http.post('/'+ this.resource + '/' + this.entityId + '/comments.json', {
          comment: {
            content: this.text,
            entity_id: this.entityId,
            entity_type: this.resource
          }
        }).then(function(response) {
          self.callback(response);
          self.text = '';
        });
      };
  	}],
  	controllerAs: 'ctrl',
  	bindToController: true,
    template: '<style>' +
                'comment-form { width: 100%; } .comment-form textarea { width: 100%; height: 69px; border: none; resize: none; }' +
                '.comment-form button { float: left; }' +
              '</style>' +
              '<div class="comment-form">' +
                '<textarea placeholder="הוסף הערה לשימוש הצוות" ng-model="ctrl.text"></textarea>' +
                '<button class="btn btn-warning" ng-click="ctrl.submit()">שלח</button>' +
              '</div>'
  };
});
