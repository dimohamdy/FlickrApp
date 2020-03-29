# FlickrApp

# Install
* Add API_Key in APILinksFactory
* Run in terminal
```
pod install
```


# App Structure

* App structure I use **MVP** with Input-Output approach **Delegate** to notify about updates.

* I use the **Repository** design pattern to act as a Data source from API and UserDefault for saveing search terms.

* Separate the data source of UITableView to other class **PhotosCollectionViewDataSource**.

* I use **CellReusable** protocol and create 2 extensions for UICollectionView to reduce code when reusing the cell.

* Use DataLoader.swift to get data from local JSON.

* Create Extension for UIImageView to download the image from the link.

* I used [SwiftLint](https://github.com/realm/SwiftLint) to enhance Swift style.

* I used [JSONExport](https://github.com/Ahmed-Ali/JSONExport) to generate model from JSON.

* I used create UI with code.

* I use  this answer to [check internet connection](https://stackoverflow.com/questions/39558868/check-internet-connection-ios-10/52998897#52998897)

* I used Cocopods.



# UnitTest
* I apply  **Arrange, Act and Assert (AAA) Pattern** in Unit Testing.
* I use mocking to Test get data from  NetworkManager, I use the same JSON file to mock data.
* Test get data from API and From Local JSON.
