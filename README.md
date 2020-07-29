# GTSheetMenuView

![Language](https://img.shields.io/badge/Language-Swift-orange)
![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey)
![License](https://img.shields.io/badge/License-MIT-brightgreen)
![Version](https://img.shields.io/badge/Version-1.0.0-blue)

#### A customizable menu presented as a sheet that can be integrated in iOS projects.

## About

GTSheetMenuView is a Swift library that can be integrated in iOS projects allowing to present a menu as a sheet from the bottom of the screen. It is highly customizable through the available public API. It's implemented in a way so initialization and configuration of `GTSheetMenuView` instances can be done in a declarative fashion.

Suitable for UIKit based projects.

## Integrating GTSheetMenuView

To integrate `GTSheetMenuView` into your projects follow the next steps:

1. Copy the repository's URL to GitHub (it can be found by clicking on the *Clone or Download* button).
2. Open your project in Xcode.
3. Go to menu **File > Swift Packages > Add Package Dependency...**.
4. Paste the URL, select the package when it appears and click Next.
5. In the *Rules* leave the default option selected (*Up to Next Major*) and click Next.
6. Select the *GTSheetMenuView* package and select the *Target* to add to; click Finish.
7. In Xcode, select your project in the Project navigator and go to *General* tab.
8. Add GTSheetMenuView framework under *Frameworks, Libraries, and Embedded Content* section.

Don't forget to import `GTSheetMenuView` module anywhere you are about to use it:

```swift
import GTSheetMenuView
```

## Usage Example

Before initializing a `GTSheetMenuView` instance, create a collection of `GTSheetMenuItemInfo` objects. Each object represents an item, and you can provide the title, and optionally a subtitle and an image upon initialization:

```swift
var items = [GTSheetMenuItemInfo]()
items.append(GTSheetMenuItemInfo(title: "Edit", subtitle: nil,image: editImage))
items.append(GTSheetMenuItemInfo(title: "Copy", subtitle: nil, image: copyImage))
items.append(GTSheetMenuItemInfo(title: "Cut", subtitle: nil, image: cutImage))
items.append(GTSheetMenuItemInfo(title: "Share", subtitle: nil, image: shareImage))
items.append(GTSheetMenuItemInfo(title: "Delete", subtitle: nil, image: deleteImage))
```

Here's an example of initializing and configuring a `GTSheetMenuView` menu. The number of methods that will be called depends on the customization you want to perform on the menu. The following is just an extended example:

```swift
GTSheetMenuView.addSheetMenuView(to: self.view)
    .set(items: items)
    .setTitle("My sheet menu")
    .setTitleFont(to: UIFont(name: "Futura", size: 19)!)
    .setSheetViewCornerRadius(15)
    .showItemImageBeforeTitle(false)
    .centerItemContent()
    .setSheetViewHorizontalPadding(leadingPadding: 10, trailingPadding: 10, forHorizontalSizeClass: .regular, verticalSizeClass: .regular)
    .setSheetViewHorizontalPadding(leadingPadding: 10, trailingPadding: 10, forHorizontalSizeClass: .regular, verticalSizeClass: .compact)
    .setItemSelectionColor(.lightGray)
    .setTitleFontForAllItems(UIFont(name: "AvenirNext-Regular", size: 17)!)
    .setTitleAlignmentForAllItems(.left)
    .setItemTitleLabelHeight(36.0)
    .setMinimumHeightForAllItems(60)
    .setItemTitleTextColor(at: 4, color: .red)
    .onDismiss {
        print("Sheet menu was dismissed!")
    }
    .onItemSelection({ (itemIndex) in
        print("Did tap at index \(itemIndex)")
        // Perform further actions...
    })
    .showAnimated()
```

![GTSheetMenuView Sample](https://gtiapps.com/custom_media/gtsheetmenuview/gtsheetmenuview_sample.png)

There are more public methods to use; see the next part for that.

By default, menu is dismissed when tapping on the overlay view. You can disable that by calling the following method:

```swift
.disableSheetMenuDismissalOnOverlayTap()
```

To manually dismiss the menu, call the following class method:

```swift
GTSheetMenuView.hideAnimated(from:duration:)
```

The initialized `GTSheetMenuView` instance can be optionally assigned to a variable:

```swift
var menu = GTSheetMenuView.addSheetMenuView(to: self.view)
    ...
    ...
```

To get the `GTSheetMenuItemInfo` object matching to a specific index, use the `getItemInfo(at:)` instance method through a menu object:

```swift
let info = menu.getItemInfo(at: 1)
```

To get the item view as a `GTSheetMenuItemView` object for a specific index, call the `getItemView(at:)` instance method through a menu object:

```swift
let itemView = menu.getItemView(at: 1)
```

Through the `itemView` it's possible to access the `title` and `subtitle` labels, as well as the `imageView` of the item view.

Please take a look at the available public API presented right next. It contains a variety of methods allowing to achieve high customization.


## Public API

```swift

// -- Class Methods

// Create and add a sheet menu view to a view. 
addSheetMenuView(to:)

// Hide and remove a sheet menu view instance animated.
hideAnimated(from:duration:)



// -- Instance Methods

// -- Appearance & Disappearance --

// It prepares a `GTSheetMenuView` for appearance by configuring any
// internal subviews and setting the necessary autolayout constraints,
// and then it presents it animated.
showAnimated(duration:completion:)


// Implement additional actions once the sheet menu view has been dismissed.
onDismiss(_:)



// -- Sheet View Width & Horizontal Padding --

// Provide a fixed width for the sheet view that will apply to all size class combinations.
setSheetViewWidth(_:)


// Provide a fixed width value for a given combination of horizontal and
// vertical size classes.
setSheetViewWidth(_:forHorizontalSizeClass:verticalSizeClass:)


// Provide leading and trailing padding values for all size class combinations.
setSheetViewHorizontalPadding(leadingPadding:trailingPadding:)


// Set the leading and trailing pardding values for specific size class combinations.
setSheetViewHorizontalPadding(leadingPadding:trailingPadding:forHorizontalSizeClass:verticalSizeClass:)



// -- Sheet View General --

// Set the background color of the menu view.
setMenuViewBackgroundColor(_:)


// Set the corner radius of the sheetview.
setSheetViewCornerRadius(_:)


// Update the menu items container view default insets.
updateItemsContainerInsets(_:)


// Specify whether the imageview of the menu items should be
// displayed before or after the title.
showItemImageBeforeTitle(_:)


// Hide the separators shown among menu items.
hideSeparators()


// Align menu item content centered horizontally.
centerItemContent()



// -- Sheet View Title --

// Set the sheet menu title.
setTitle(_:)


// Set the sheet menu title's text color.
setTitleTextColor(to:)


// Set the sheet menu title's font.
setTitleFont(to:)


// Set the sheet menu title's text alignment.
setTitleTextAlignment(_:)



// -- Items Title --

// Set the title font for all menu items.
setTitleFontForAllItems(_:)


// Set the title font for the menu item at the given index.
setItemTitleFont(at:font:)


// Set the title text color for all menu items.
setTitleTextColorForAllItems(_:)


// Set the title text color for the menu item at the given index.
setItemTitleTextColor(at:color:)


// Set title text alignment for all menu items.
setTitleAlignmentForAllItems(_:)


// Set title text alignment for the menu item at the given index.
setItemTitleAlignment(at:alignment:)


// Set the height of the title label for all items.
setItemTitleLabelHeight(_:)


// -- Items ImageView --

// Set the size (width and height) of the image view for all items.
setItemImageViewSize(_:)


// Set the content mode of the imageview for all items.
setItemImageViewContentMode(_:)



// -- Items Height --

// Set the minimum desired height for all menu items.
setMinimumHeightForAllItems(_:)


// Set the minimum desired height for the item at the given index.
setMinimumItemHeight(at:height:)



// -- Subtitle --

// Specify the text color of the subtitle for all items.
setSubtitleTextColor(_:)


// Specify the text color of the subtitle for the item at the given index.
setSubtitleTextColor(at:color:)


// Set the font of the subtitle for all items.
setSubtitleFontForAllItems(_:)


// Set the subtitle font for the item at the given index.
setSubtitleFont(at:font:)


// Set the alignment of the subtitle for all items.
setSubtitleAlignmentForAllItems(_:)


// Set the subtitle text alignment for the item at the given index.
setSubtitleAlignment(at:alignment:)



// -- Overlay --

// Set a custom background color for the overlay view.
setOverlayColor(_:)


// Disable dismissing the sheet menu view by tapping on the overlay view.
disableSheetMenuDismissalOnOverlayTap()



// -- Set Menu Items --

// Provide the items to display as a collection of `GTSheetMenuItemInfo` elements.
set(items:)



// -- Get Item & Item View --

// Get the menu item view at the given index.
getItemView(at:)


// Get the menu item at the given index as a `GTSheetMenuViewInfo` object.
getItemInfo(at:)



// -- Item Selection --

// Perform an action upon an item's selection.
onItemSelection(_:)


// Set the selection color shown when an item is tapped.
setItemSelectionColor(_:)

```

## Remarks

* See Xcode's Quick Help for further details about each method presented above.

* All methods above return a `GTSheetMenuView` instance. Exceptions to that are the following:
    *  `hideAnimated(from:duration:)` class method: Does not return any value.
    *  `getItemView(at:)`: Returns a `GTSheetMenuItemView` object.
    *  `getItemInfo(at:)`: Returns a `GTSheetMenuItemInfo` object.

* Assigning the initialized `GTSheetMenuView` instance to a variable or property is optional, as all methods that return it have been marked with the `discardableResult` attribute.

* Always call the `showAnimated(duration:completion:)` method as the last one in the series of methods you'll use to configure the sheet menu.


## License

GTSheetMenuView is licensed under the MIT license.
