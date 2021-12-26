# Restaurant Details App for iOS

RestaurantDetails is an iPhone app that uses the `Yelp API` to display restaurant details. 

## Requirements

* iOS 15.0+
* Swift 5

## User Interface

Used `storyboard` for `grid view` and `programmatic UI` for details view and the rest of other custom views.

The app is adapted for all iPhone size classes/screen sizes thanks to the AutoLayout technology.

## Networking

Used `URLSession` to implement a simple `API Client` for downloading data from endpoints indicated by URLs.

## Persistence & Storage

Used `File/disk storage` with `FileManager` to persist favorites through app restarts.

## Accessibility

Used the native `accessibility API` to support dynamic font size.

## Automated Tests

The business logic is covered by Unit Tests using the native `XCTest` framework.

## Third party libraries

The app uses `SDWebImage` library as an async image downloader. It has a great community behind it and it is actively maintained. It has cache support which was a strong reason to use it and not "reinvent the wheel".
