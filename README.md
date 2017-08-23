# Daylight

![Daylight](https://github.com/bakkenbaeck/daylight-ios/blob/master/GitHub/screenshots.png?raw=true)

A beautiful app that will let you know how much sun you have today.

## Running the project

- Open terminal and navigate project folder and run below command

  ```$carthage update```

- Open `Project.xcodeproj` and run

## What's interesting about this project?

### Uses a JavaScript library for the sun calculation

Shares the same sun calculation library as the web app. It uses JavaScriptCore to load suncalc.js, you can find the library here: https://github.com/mourner/suncalc. The bridge that converts JavaScript to Swift can be found in [SunCalc.swift](https://github.com/bakkenbaeck/daylight-ios/blob/master/Library/SunCalc.swift).
