# PROJECT_NAME

PROJECT_DESCRIPTION

## Running the project

- Open `Project.xcodeproj` and run

## Updating generated models

- Install [mogenerator](http://rentzsch.github.io/mogenerator/)
- Run the following command in Terminal.app

```
mogenerator \
--swift \
--model Library/Models/DataModel.xcdatamodeld/DataModel.xcdatamodel \
--output-dir Library/Models \
--v2
```
