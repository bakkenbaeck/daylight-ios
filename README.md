# Daylight

![Daylight](https://github.com/bakkenbaeck/daylight-ios/blob/master/GitHub/screenshots.png?raw=true)

A beautiful app that will let you know how much sun you have today.

This app uses your device's GPS to determine your location and current date to calculate the length of the day

In addition to displaying sunrise and sunset times, users can also view a graph of the day's daylight hours (sunrise, sunset, and civil twilight)

## Running the project

Follow these steps to install and run the Daylight iOS project from GitHub:
- Clone the repository to your local machine using the command:
```jsx
git clone https://github.com/bakkenbaeck/daylight-ios.git
```
- Navigate to the project directory
```jsx
cd daylight-ios
```
- Install the project dependencies using CocoaPods
    - Install CocoaPods using the command:
    ```jsx
    sudo gem install cocoapods
    ``` 
    - Command for installing dependencies
    ```jsx
    pod install
    ``` 
- Open the project in Xcode by running:
```jsx
open Daylight.xcworkspace
``` 
- Build and run the project
    - Select a simulator or a connected device and click the "Run" button

## What's interesting about this project?

### Uses a JavaScript library for the sun calculation

Shares the same sun calculation library as the web app. It uses JavaScriptCore to load suncalc.js, you can find the library here: https://github.com/mourner/suncalc. The bridge that converts JavaScript to Swift can be found in [SunCalc.swift](https://github.com/bakkenbaeck/daylight-ios/blob/master/Library/SunCalc.swift).

## License
Daylight is licensed under [The MIT License](/LICENSE). 
You are free to download the source code and build a binary using Xcode. 

## Citation
If you use the Daylight iOS project in your work, please cite it in the following manner:
```jsx
Bakken & Bæck. Daylight iOS. GitHub repository, https://github.com/bakkenbaeck/daylight-ios.
``` 