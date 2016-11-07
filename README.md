# HearthCards [![Build Status](https://travis-ci.org/terryma/hearth.cards.svg)](https://travis-ci.org/terryma/hearth.cards)
This is the codebase for [http://terry.ma/hearth.cards/](http://terry.ma/hearth.cards/), a tool for [HearthStone](http://us.battle.net/hearthstone/en/) players to browse and filter all the cards in the game.

# Development
* Run ```grunt serve``` to run the local server for testing.
* Run ```grunt continous-test``` to run unit tests using karma/jasmine/phantomjs. This runs the test continuously in the background as you make changes to scripts/tests.
* Run ```grunt test``` to run unit tests once.
* Run ```grunt build``` to build the project. This creates ```/dist``` which contains the deployable site.
* Run ```grunt release``` to run unit test, build, and deploy the project to S3.

# TODO
## Features/Bugs
* Add tooltip next to search bar to contain example search queries
* Support col-xxs-* to have a 1 column layout for phones: http://stackoverflow.com/questions/24066059/bootstrap-3-adding-a-new-set-of-columns
* Figure out how to separate out card type with card text. "mech" returns all mech types, but no card with "mech" in the card text.
* Support 'by' keyword. "1 mana spell by class"
* Support ranges. ">9 mana minions" or "1-3 attack minions"
* Support 'or'. "hunter or neutral" to show all collectable cards for hunter
* Search for synergies? Maybe use data from [http://heartharena.com](http://heartharena.com)

## Optimizations
* Support file versioning on images and other static assets. This would allow to cache images on CloudFront/browser indefinitely
* gzip files to further reduce cost
* SEO
