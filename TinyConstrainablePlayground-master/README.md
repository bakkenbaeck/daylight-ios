# TinyConstrainablePlayground
Workspace containing a Playground in which you can use [TinyConstraints](https://github.com/roberthein/TinyConstraints) via [Carthage](https://github.com/Carthage/Carthage) (only for XCode 10)

# Usage
- Open the `TinyConstrainablePlayground.xcworkspace` file in XCode 10
- Don't forget to Build the Project, otherwise the Framework won't be recognizes
- Play around in MyPlayground.playground

# Updating carthage
- Update TinyConstraints via Carthage like you normally do (`carthage update TinyCOnstraints --platform iOS`)
- Remove TinyConstraints.xcodeproj in the Project Navigator, but *only* remove the Reference:
![image](readmeFiles/removeReference.png)
- Right click on `TinyConstrainablePlayground` in the Project Navigator and select `Add Files to "TinyConstrainablePlayground"...`:
![image](readmeFiles/addFiles.png)
- Navigate to `Carthage > Checkouts > TinyConstraints` and add `TinyConstraints.xcodeproj`:
![image](readmeFiles/navigate.png)
- Don't forget to Build the Project, otherwise the Framework won't be recognizes


