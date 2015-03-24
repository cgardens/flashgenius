#Flash Genius / Regression Fit Knowledge Cards (RFNC)

creators: cgardens, imears, and rilkevb

##Summary

Want to learn more faster and better? This app is an adaptive flash-card app. As you study, the app models your performance and learns about how you learn. It tells you what you should study and when in order to learn in the most effecient manner possible. In this way, you learn more in less time time and remember it for longer. Happy learning!

RFNC is a flash card app that learns from your performance on deck so that it can help you optimize your learning. It's based on the theory that knowledge decays at a logarithmic rate, and that there is an optimal time in that curve to test your knowledge in order to solidify it in your memory. RFNC will let you know when it's time to review the deck, your current level of mastery on a subject, and a predicted time by which you will gain mastery. The more you use the app, the better it will be able to determine how often you should study your deck in order to master your deck most quickly.

We are currently on version 1. Version 1 is meant to be a proof of concept in building a responsive learning app.

RFNC is built on rails. Login is handled via google oauth.

##Try it out
RFNC is live at [https://flashgenius.herokuapp.com](https://flashgenius.herokuapp.com)

##Installation

As long as you have the credentials for the google plus api, you should be able to clone down this repo and get it up and running by following these steps:
1. clone repo
2. bundle install
3. be rake db:migrate
4. (optional) be rake db:seed if you want to try out one of our pre-made decks. Includes an algorithms deck and basic JS deck.
5. in the root directory create a .env file with the following keys: 'GOOGLE_CLIENT_ID=<YOUR GOOGLE CLIENT ID>' and 'GOOGLE_CLIENT_SECRET=<YOUR GOOGLE CLIENT ID>'. You will have to have a google api account with google+ enabled. Make sure to set the callback url to localhost:3000 and localhost:3000/welcome/oauth2callback on the google dashboard--assuming you're serving the app locally.
6. rails s and have a blast!

##Testing

RFNC currently has a small controller test suite. We are still building out complete test coverage.

