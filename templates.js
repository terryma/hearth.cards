angular.module('hearthCardsApp').run(['$templateCache', function($templateCache) {
  'use strict';

  $templateCache.put('views/card.html',
    "<div class=\"col-lg-2 col-md-3 col-sm-4 col-xs-6 float-shadow card-container\">\n" +
    "  <div class=\"card center-block\">\n" +
    "    <img ng-src=\"images/{{card.img}}\" class=\"img-responsive center-block card-img\">\n" +
    "    <img ng-src=\"images/token.png\" ng-if=\"card.isToken\" ng-show=\"loaded\" class=\"token img-responsive\">\n" +
    "    <img ng-src=\"images/{{card.class == nil ? 'neutral' : card.class.toLowerCase()}}.png\" ng-show=\"loaded\"\n" +
    "    ng-if=\"!card.isToken && (card.class == nil || card.class.indexOf(' ') === -1)\" class=\"token img-responsive\">\n" +
    "  </div>\n" +
    "</div>\n"
  );


  $templateCache.put('views/main.html',
    "<!-- Included from ng-include. This creates a child scope --!>\n" +
    "<div class=\"row\" id=\"search\">\n" +
    "  <div class=\"col-lg-offset-3 col-lg-6 col-md-offset-2 col-md-8 col-sm-offset-1\n" +
    "    col-sm-10 col-xs-offset-1 col-xs-10\" >\n" +
    "    <div id=\"custom-search-input\" class=\"input-group input-group-lg\">\n" +
    "      <input ng-model=\"$parent.query\" ng-change=\"search(query)\"\n" +
    "      ng-model-options=\"{debounce:200}\" type=\"search\" class=\"search-query\n" +
    "      form-control\" placeholder=\"Try 'legendary mech', '2 mana mage spell', or '2/3 gvg minion with freeze'. Click on ? for more help\" autofocus>\n" +
    "      <span class=\"input-group-btn\">\n" +
    "        <button class=\"btn search-btn\" type=\"button\">\n" +
    "          <span class=\"glyphicon glyphicon-search\"></span>\n" +
    "        </button>\n" +
    "      </span>\n" +
    "      <span class=\"input-group-btn\">\n" +
    "        <a tabindex=\"0\" class=\"btn help-btn\" role=\"button\" data-toggle=\"popover\"\n" +
    "        title=\"Help\" data-container=\"body\" data-trigger=\"click\">\n" +
    "          <span class=\"glyphicon glyphicon-question-sign\"></span>\n" +
    "        </a>\n" +
    "      </span>\n" +
    "    </div>\n" +
    "  </div>\n" +
    "</div>\n" +
    "\n" +
    "<div id=\"help-popover-content\" class=\"hidden\">\n" +
    "  <div>\n" +
    "  <h4>Examples:</h4>\n" +
    "  <ul>\n" +
    "    <li><a href=\"#collectible murlocs\">collectible murlocs</li>\n" +
    "    <li><a href=\"#collectible legendary mech\">collectible legendary mech</a></li>\n" +
    "    <li><a href=\"#2 mana mage spell\">2 mana mage spell</a></li>\n" +
    "    <li><a href=\"#2/3 gvg minion with freeze\">2/3 gvg minion with freeze</a></li>\n" +
    "    <li><a href=\"#loe collectible spells\">loe collectible spells</a></li>\n" +
    "  </ul>\n" +
    "  </div>\n" +
    "\n" +
    "  <div>\n" +
    "  <h4>Filter by class:</h4>\n" +
    "  <a href=\"#druid\">druid</a>\n" +
    "  <a href=\"#hunter\">hunter</a>\n" +
    "  <a href=\"#mage\">mage</a>\n" +
    "  <a href=\"#paladin\">paladin</a>\n" +
    "  <a href=\"#priest\">priest</a>\n" +
    "  <a href=\"#rogue\">rogue</a>\n" +
    "  <a href=\"#shaman\">shaman</a>\n" +
    "  <a href=\"#warlock\">warlock</a>\n" +
    "  <a href=\"#warrior\">warrior</a>\n" +
    "  <a href=\"#neutral\">neutral</a>\n" +
    "  </div>\n" +
    "\n" +
    "  <div>\n" +
    "  <h4>Show only collectible cards:</h4>\n" +
    "  <a href=\"#collectible\">collectible</a>/<a href=\"#collectable\">collectable</a>/<a href=\"#draftable\">draftable</a>\n" +
    "  </div>\n" +
    "\n" +
    "  <div>\n" +
    "  <h4>Filter by type:</h4>\n" +
    "  <a href=\"#minion\">minion</a>\n" +
    "  <a href=\"#weapon\">weapon</a>\n" +
    "  <a href=\"#spell\">spell</a>\n" +
    "  </div>\n" +
    "\n" +
    "  <div>\n" +
    "  <h4>Filter by mana/attack/health:</h4>\n" +
    "  <a href=\"#1 mana\">1 mana</a>\n" +
    "  <a href=\"#2 attack\">2 attack</a>\n" +
    "  <a href=\"#3 health\">3 health</a>\n" +
    "  <a href=\"#7/7 minion\">7/7 minion</a>\n" +
    "  </div>\n" +
    "\n" +
    "  <div>\n" +
    "  <h4>Filter by rarity:</h4>\n" +
    "  <a href=\"#legendary\">legendary</a>\n" +
    "  <a href=\"#epic\">epic</a>\n" +
    "  <a href=\"#rare\">rare</a>\n" +
    "  <a href=\"#common\">common</a>\n" +
    "  <a href=\"#free\">free</a>\n" +
    "  </div>\n" +
    "\n" +
    "  <div>\n" +
    "  <h4>Filter by race:</h4>\n" +
    "  <a href=\"#beast\">beast</a>\n" +
    "  <a href=\"#demon\">demon</a>\n" +
    "  <a href=\"#dragon\">dragon</a>\n" +
    "  <a href=\"#mech\">mech</a>\n" +
    "  <a href=\"#murloc\">murloc</a>\n" +
    "  <a href=\"#pirate\">pirate</a>\n" +
    "  <a href=\"#totem\">totem</a>\n" +
    "  </div>\n" +
    "  \n" +
    "  <div>\n" +
    "  <h4>Filter by set:</h4>\n" +
    "  <ul>\n" +
    "  <li><a href=\"#basic\">basic</a></li>\n" +
    "  <li><a href=\"#classic\">classic</a></li>\n" +
    "  <li><a href=\"#reward\">reward</a></li>\n" +
    "  <li><a href=\"#promo\">promo</a></li>\n" +
    "  <li><a href=\"#gvg\">gvg (Goblin vs. Gnomes)</a></li>\n" +
    "  <li><a href=\"#naxx\">naxx (Curse of Naxxramas)</a></li>\n" +
    "  <li><a href=\"#brm\">brm (Blackrock Mountain)</a></li>\n" +
    "  <li><a href=\"#tgt\">tgt (The Grand Tournament)</a></li>\n" +
    "  <li><a href=\"#loe\">loe (League of Explorers)</a></li>\n" +
    "  <li><a href=\"#wog\">wog (Whisper of the Old Gods)</a></li>\n" +
    "  <li><a href=\"#kara\">kara (One Night in Karazhan)</a></li>\n" +
    "  <li><a href=\"#msg\">msg (Mean Streets of Gadgetzan)</a></li>\n" +
    "  </ul>\n" +
    "  </div>\n" +
    "  \n" +
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
