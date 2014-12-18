angular.module('hearthCardsApp').run(['$templateCache', function($templateCache) {
  'use strict';

  $templateCache.put('views/card.html',
    "<div class=\"col-lg-2 col-md-3 col-sm-4 col-xs-6 float-shadow card-container\">\n" +
    "  <div class=\"card center-block\">\n" +
    "    <img ng-src=\"images/{{card.img}}\" class=\"img-responsive center-block card-img\">\n" +
    "    <img ng-src=\"images/token.png\" ng-if=\"card.isToken\" ng-show=\"loaded\" class=\"token img-responsive\">\n" +
    "    <img ng-src=\"images/{{card.class == nil ? 'neutral' : card.class.toLowerCase()}}.png\" ng-show=\"loaded\" ng-if=\"!card.isToken\" class=\"token img-responsive\">\n" +
    "  </div>\n" +
    "</div>\n"
  );


  $templateCache.put('views/main.html',
    "<div class=\"row\" id=\"search\">\n" +
    "  <div class=\"col-lg-offset-3 col-lg-6 col-md-offset-2 col-md-8 col-sm-offset-1\n" +
    "    col-sm-10 col-xs-offset-1 col-xs-10\" >\n" +
    "    <div id=\"custom-search-input\" class=\"input-group input-group-lg\">\n" +
    "      <input ng-model=\"query\" ng-change=\"search(query)\"\n" +
    "      ng-model-options=\"{debounce:200}\" type=\"search\" class=\"search-query\n" +
    "      form-control\" placeholder=\"try 'legendary mech', '2 mana mage spell', or '2/3 gvg minion with freeze'\" autofocus>\n" +
    "      <span class=\"input-group-btn\">\n" +
    "        <button class=\"btn\" type=\"button\">\n" +
    "          <span class=\"glyphicon glyphicon-search\"></span>\n" +
    "        </button>\n" +
    "      </span>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "</div>\n" +
    "\n" +
    "<div class=\"row text-center\" ng-cloak>\n" +
    "  <div class=\"col-lg-12\">\n" +
    "    <div ng-class=\"percentCircleCssClass()\">\n" +
    "      <span>{{filtered.length}}</span>\n" +
    "      <div class=\"slice\">\n" +
    "        <div class=\"bar\"></div>\n" +
    "        <div class=\"fill\"></div>\n" +
    "      </div>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "</div>\n" +
    "\n" +
    "<div ng-switch=\"filtered.length\" ng-cloak>\n" +
    "  <div ng-switch-when=\"0\" class=\"notfound text-center\">\n" +
    "    <h1>try another search</h1>\n" +
    "    <img src=\"images/error-bg.png\" class=\"img-responsive center-block\">\n" +
    "  </div>\n" +
    "\n" +
    "  <div ng-switch-when=\"1\" class=\"row\" id=\"cards\">\n" +
    "    <!-- <div class=\"col-lg-4 col-md-3 col-sm-4 col-xs-6\"> -->\n" +
    "      <!-- <dl class=\"dl-horizontal\"> -->\n" +
    "        <!-- <dt>Class</dt> -->\n" +
    "        <!-- <dd>{{card.class == nil ? \"Neutral\" : card.class}}</dd> -->\n" +
    "        <!-- <dt>Mana</dt> -->\n" +
    "        <!-- <dd>{{card.mana}}</dd> -->\n" +
    "        <!-- <dt>Attack</dt> -->\n" +
    "        <!-- <dd>{{card.attack}}</dd> -->\n" +
    "        <!-- <dt>Health</dt> -->\n" +
    "        <!-- <dd>{{card.health}}</dd> -->\n" +
    "        <!-- <dt>Type</dt> -->\n" +
    "        <!-- <dd>{{card.type}}</dd> -->\n" +
    "        <!-- <dt>Race</dt> -->\n" +
    "        <!-- <dd>{{card.race}}</dd> -->\n" +
    "        <!-- <dt>Set</dt> -->\n" +
    "        <!-- <dd>{{card.set}}</dd> -->\n" +
    "        <!-- <dt>Rarity</dt> -->\n" +
    "        <!-- <dd>{{card.rarity}}</dd> -->\n" +
    "        <!-- <dt>Text</dt> -->\n" +
    "        <!-- <dd>{{card.text}}</dd> -->\n" +
    "      <!-- </dl> -->\n" +
    "    <!-- </div> -->\n" +
    "    <card card=\"filtered[0]\" ng-click=\"show(filtered[0])\"></card>\n" +
    "    <div class=\"col-lg-2 col-md-3 col-sm-4 col-xs-6\" ng-if=\"relatedCards.length > 0\">\n" +
    "      <img ng-src=\"images/arrow-blue.png\" class=\"img-responsive center-block\">\n" +
    "    </div>\n" +
    "    <div ng-if=\"relatedCards.length > 0\">\n" +
    "      <card card=\"related\" ng-click=\"show(related)\" ng-repeat=\"related in relatedCards track by related.id\"></card>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "\n" +
    "  <div ng-switch-default class=\"row\" id=\"cards\" infinite-scroll=\"load()\" infinite-scroll-distance=\"2\">\n" +
    "    <card card=\"card\" ng-click=\"show(card)\" ng-repeat=\"card in shown track by card.id\"></card>\n" +
    "  </div>\n" +
    "</div>\n" +
    "\n"
  );

}]);
