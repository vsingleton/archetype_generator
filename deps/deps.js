(function(angular) {
'use strict';
angular.module('liferay-faces-deps', [])
	.controller('depsController', ['$scope', function($scope) {

//		var builds = [
//			{ name: 'pom.xml',		url: '' },
//			{ name: 'build.gradle',	url: '' }
//		];

		var jsfs = [
			{ name: 'jsf-2.1',		url: '' },
			{ name: 'jsf-2.2',		url: '' },
			{ name: 'jsf-2.3',		url: '' }
		];

		var versions = [
			{ name: '1.0.x',			jsfs: [jsfs[0], jsfs[1], jsfs[2]] },
			{ name: '2.0.x',			jsfs: [jsfs[0], jsfs[1], jsfs[2]] },
			{ name: '6.2.x',			jsfs: [jsfs[0], jsfs[1]] },
			{ name: '7.0.x',			jsfs: [jsfs[1]] }
		];

		var servers = [
			{ name: 'liferay',		versions: [versions[2], versions[3]] },
			{ name: 'pluto',			versions: [versions[1]] },
			{ name: 'webapp',			versions: [versions[0]] }
		];

		var servlets = [
			{ name: 'war',			servers: servers }
		];

		var suites = [
			{ name: 'jsf',				servlets: servlets },
			{ name: 'icefaces',		servlets: servlets },
			{ name: 'alloy',			servlets: servlets },
			{ name: 'metal',			servlets: servlets },
			{ name: 'primefaces',	servlets: servlets },
			{ name: 'richfaces',		servlets: servlets }
		];

		$scope.data = {
			suites: suites,

			suite:	{ name: '' },
			servlet:	{ name: '' },
			server:	{ name: '' },
			version:	{ name: '' },
			jsf:		{ name: '' },
//			build:	{ name: '' }
		};

		$scope.setServer = function() {

			if ($scope.data.server.name == 'pluto') { $scope.data.versions = [ versions[1] ]; }
			if ($scope.data.server.name == 'pluto') { $scope.data.version.name = versions[1].name; }
			if ($scope.data.server.name == 'pluto') { $scope.data.version.jsfs = versions[1].jsfs; }

			if ($scope.data.server.name == 'webapp') { $scope.data.versions = [ versions[0] ]; }
			if ($scope.data.server.name == 'webapp') { $scope.data.version.name = versions[0].name; }
			if ($scope.data.server.name == 'webapp') { $scope.data.version.jsfs = versions[0].jsfs; }
		}

		$scope.setSuite = function() {
			console.log("servlets[0].name = " + servlets[0].name);
			$scope.data.servlets = servlets;
			$scope.data.servlet.name = servlets[0].name;
			$scope.data.servlet.servers = servers;
		};

	}]);
})(window.angular);

