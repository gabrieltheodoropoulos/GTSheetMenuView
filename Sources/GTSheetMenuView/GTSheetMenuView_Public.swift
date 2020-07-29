//
//  GTSheetMenuView_Public.swift
//

import UIKit

extension GTSheetMenuView {
    
    // MARK: - Appearance & Disappearance
    
    /**
     It prepares a `GTSheetMenuView` for appearance by configuring any
     internal subviews and setting the necessary autolayout constraints,
     and then it presents it animated.
     
     - Parameter duration: The animation duration. Default value is 0.4 seconds.
     - Parameter completion: An optional completion handler that gets called once
     the appearance animation is finished.
     */
    @discardableResult public func showAnimated(duration: TimeInterval = 0.4, completion: (() -> Void)? = nil) -> GTSheetMenuView {
        guard prepareToShow() else { return self }
        
        // Perform appearance animation.
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 1.0, options: .curveLinear, animations: {
            self.overlayView?.alpha = 1.0
            self.sheetView?.transform = CGAffineTransform.identity
        }) { (_) in
            completion?()
        }
    
        return self
    }
    
    
    /**
     Implement additional actions once the sheet menu view has been dismissed.
     */
    @discardableResult public func onDismiss(_ handler: @escaping () -> Void) -> GTSheetMenuView {
        didDismissHandler = handler
        return self
    }
    
    
    // MARK: - Sheet View Width & Horizontal Padding
    
    /**
     Provide a fixed width for the sheet view that will apply to all size class combinations.
     
     Note that `setSheetViewWidth(_:forHorizontalSizeClass:verticalSizeClass:)` method has a
     higher priority than this one, so any width that is set won't be considered if that method
     is called for specific size class combinations.
     
     This method updates the autolayout constraints of the sheet view.
     
     - Parameter width: The sheet view width.
     - Returns: Self instance with updated autolayout constraints that use the given width.
     */
    @discardableResult public func setSheetViewWidth(_ width: CGFloat) -> GTSheetMenuView {
        configuration.sheetViewWidth = width
        updateSheetViewWidth(with: width)
        return self
    }
    
    
    /**
     Provide a fixed width value for a given combination of horizontal and
     vertical size classes.
     
     Use this method if you want to set a specific width to sheet view for
     a certain size class combination. Note that for size class combinations that
     no width is provided, one of the following will apply in the order shown here:
     
     1. A fixed width will apply that was given to `setSheetViewWidth(_:)` method.
     2. Leading and trailing constraints will be set using the horizontal padding
     given to `setSheetHorizontalPadding(leadingPadding:trailingPadding:)` method.
     3. Original leading and trailing constraints will be set.
     
     This method updates the autolayout constraints of the sheet view.
     
     - Parameter width: The sheet view width.
     - Parameter hSizeClass: The horizontal size class value.
     - Parameter vSizeClass: The vertical size class value.
     - Returns: Self instance with updated autolayout constraints.
     */
    @discardableResult public func setSheetViewWidth(_ width: CGFloat, forHorizontalSizeClass hSizeClass: UIUserInterfaceSizeClass,
                    verticalSizeClass vSizeClass: UIUserInterfaceSizeClass) -> GTSheetMenuView {
        configuration.sheetViewWidthForLayoutRules.append((width, LayoutRules(horizontalSizeClass: hSizeClass, verticalSizeClass: vSizeClass)))
        return self
    }
    
    
    /**
     Provide leading and trailing padding values for all size class combinations.
     
     Note that `setSheetViewHorizontalPadding(leadingPadding:trailingPadding:forHorizontalSizeClass:verticalSizeClass:)`
     method has a higher priority than this method.
     
     This method updates the autolayout constraints of the sheet view.
     
     - Parameter leadingPadding: The padding for the leading anchor of the sheet view.
     - Parameter trailingPadding: The padding for the trailing anchor of the sheet view.
     */
    @discardableResult public func setSheetViewHorizontalPadding(leadingPadding: CGFloat, trailingPadding: CGFloat) -> GTSheetMenuView {
        configuration.horizontalPadding = HorizontalPadding(leading: leadingPadding, trailing: trailingPadding * (-1.0))
        return self
    }
    
    
    /**
     Set the leading and trailing pardding values for specific size class combinations.
     
     Use this method if you want to set a leading and trailing padding for specific
     combinations of horizontal and vertical size classes. For size class combinations
     that no specific horizontal padding is provided, one of the following will happen
     in order of appearance:
     
     1. If a generic horizontal padding is provided with the `setSheetViewHorizontalPadding(leadingPadding:trailingPadding:)`
     method, then this will be applied.
     2. No leading and trailing padding will be applied at all.
     
     - Parameter leadingPadding: The padding for the leading anchor of the sheet view.
     - Parameter trailingPadding: The padding for the trailing anchor of the sheet view.
     - Parameter hSizeClass: The horizontal size class.
     - Parameter vSizeClass: The vertical size class.
     */
    @discardableResult public func setSheetViewHorizontalPadding(leadingPadding: CGFloat, trailingPadding: CGFloat,
                                              forHorizontalSizeClass hSizeClass: UIUserInterfaceSizeClass,
                                              verticalSizeClass vSizeClass: UIUserInterfaceSizeClass) -> GTSheetMenuView {
        
        configuration.horizontalPaddingForLayoutRules.append((HorizontalPadding(leading: leadingPadding, trailing: trailingPadding * (-1.0)),
                                                              LayoutRules(horizontalSizeClass: hSizeClass, verticalSizeClass: vSizeClass)))
        return self
    }
    
    
    // MARK: - Sheet View General
    
    /**
     Set the background color of the menu view.
     */
    @discardableResult public func setMenuViewBackgroundColor(_ color: UIColor) -> GTSheetMenuView {
        configuration.backgroundColor = color
        return self
    }
    
    
    /**
     Set the corner radius of the sheetview.
     */
    @discardableResult public func setSheetViewCornerRadius(_ radius: CGFloat) -> GTSheetMenuView {
        configuration.cornerRadius = radius
        sheetView?.layer.cornerRadius = radius
        return self
    }
    
    
    /**
     Update the menu items container view default insets.
     
     Default value is: `UIEdgeInsets(top: 8.0, left: 20.0, bottom: 20.0, right: 20.0)`.
     
     - Parameter insets: A `UIEdgeInsets` value with the new top, right,
     bottom, left inset values for the menu items container view.
     */
    @discardableResult public func updateItemsContainerInsets(_ insets: UIEdgeInsets) -> GTSheetMenuView {
        configuration.itemsContainerInsets = insets
        return self
    }
    
    
    /**
     Specify whether the imageview of the menu items should be displayed before or after the title.
     
     By default imageview is displayed after the title.
     */
    @discardableResult public func showItemImageBeforeTitle(_ imageBeforeTitle: Bool) -> GTSheetMenuView {
        configuration.imageBeforeTitle = imageBeforeTitle
        return self
    }
    
    
    /**
     Hide the separators shown among menu items.
     */
    @discardableResult public func hideSeparators() -> GTSheetMenuView {
        configuration.showSeparators = false
        return self
    }
    
    
    /**
     Align menu item content centered horizontally.
     */
    @discardableResult public func centerItemContent() -> GTSheetMenuView {
        configuration.centerContent = true
        return self
    }
    
    
    // MARK: - Sheet View Title
    
    /**
     Set the sheet menu title.
     
     If no title is provided, title label is not shown. If it's provided,
     then sheet view's height is updated accordingly so it fits the
     title label.
     */
    @discardableResult public func setTitle(_ title: String) -> GTSheetMenuView {
        configuration.title = title
        return self
    }
    
    
    /**
     Set the sheet menu title's text color.
     */
    @discardableResult public func setTitleTextColor(to color: UIColor) -> GTSheetMenuView {
        configuration.titleTextColor = color
        return self
    }
    
    
    /**
     Set the sheet menu title's font.
     */
    @discardableResult public func setTitleFont(to font: UIFont) -> GTSheetMenuView {
        configuration.titleFont = font
        return self
    }
    
    
    /**
     Set the sheet menu title's text alignment.
     */
    @discardableResult public func setTitleTextAlignment(_ alignment: NSTextAlignment) -> GTSheetMenuView {
        configuration.titleAlignment = alignment
        return self
    }
    
    
    // MARK: - Items Title
    
    /**
     Set the title font for all menu items.
     */
    @discardableResult public func setTitleFontForAllItems(_ font: UIFont) -> GTSheetMenuView {
        configuration.itemTitleFont = font
        return self
    }
    
    
    /**
     Set the title font for the menu item at the given index.
     */
    @discardableResult public func setItemTitleFont(at index: Int, font: UIFont) -> GTSheetMenuView {
        configuration.specificTitleFont.append((index, font))
        return self
    }
    
    
    /**
     Set the title text color for all menu items.
     */
    @discardableResult public func setTitleTextColorForAllItems(_ color: UIColor) -> GTSheetMenuView {
        configuration.itemTitleTextColor = color
        return self
    }
    
    
    /**
     Set the title text color for the menu item at the given index.
     */
    @discardableResult public func setItemTitleTextColor(at index: Int, color: UIColor) -> GTSheetMenuView {
        configuration.specificTitleColor.append((index, color))
        return self
    }
    
    
    /**
     Set title text alignment for all menu items.
     */
    @discardableResult public func setTitleAlignmentForAllItems(_ alignment: NSTextAlignment) -> GTSheetMenuView {
        configuration.itemTitleAlignment = alignment
        return self
    }
    
    
    /**
     Set title text alignment for the menu item at the given index.
     */
    @discardableResult public func setItemTitleAlignment(at index: Int, alignment: NSTextAlignment) -> GTSheetMenuView {
        configuration.specificTitleAlignment.append((index, alignment))
        return self
    }
    

    /**
     Set the height of the title label for all items.
     
     Default height is 24.0pt.
     
     - Parameter height: The new height for the title label to apply to all items.
     */
    @discardableResult public func setItemTitleLabelHeight(_ height: CGFloat) -> GTSheetMenuView {
        configuration.titleLabelHeight = height
        return self
    }
    
    
    // MARK: - Items ImageView
    
    /**
     Set the size (width and height) of the image view for all items.
     
     Default size is 24x24pt.
     */
    @discardableResult public func setItemImageViewSize(_ size: CGSize) -> GTSheetMenuView {
        configuration.imageViewSize = size
        return self
    }
    
    
    /**
     Set the content mode of the imageview for all items.
     
     Default content mode is `scaleAspectFit`.
     
     - Parameter contentMode: The new content mode to apply to imageviews of all items.
     */
    @discardableResult public func setItemImageViewContentMode(_ contentMode: UIView.ContentMode) -> GTSheetMenuView {
        configuration.imageViewContentMode = contentMode
        return self
    }
    
    
    // MARK: - Items Height
    
    /**
     Set the minimum desired height for all menu items.
     
     If subtitle must be displayed, the height of the items displaying
     the subtitle is increased automatically so it fits the subtitle
     taking into account the subtitle's font.
     
     Default height is 50pt.
     */
    @discardableResult public func setMinimumHeightForAllItems(_ height: CGFloat) -> GTSheetMenuView {
        configuration.itemsHeight = height
        return self
    }
    
    
    /**
     Set the minimum desired height for the item at the given index.
     
     If subtitle must be displayed for the specified menu item, then the
     height is increased by 32pt.
     
     Default height is 50pt.
     */
    @discardableResult public func setMinimumItemHeight(at index: Int, height: CGFloat) -> GTSheetMenuView {
        configuration.specificItemHeight.append((index, height))
        return self
    }
    
    
    
    // MARK: - Subtitle
    
    /**
     Specify the text color of the subtitle for all items.
     */
    @discardableResult public func setSubtitleTextColor(_ color: UIColor) -> GTSheetMenuView {
        configuration.subtitleTextColor = color
        return self
    }
    
    
    /**
     Specify the text color of the subtitle for the item at the given index.
     */
    @discardableResult public func setSubtitleTextColor(at index: Int, color: UIColor) -> GTSheetMenuView {
        configuration.specificSubtitleTextColor.append((index, color))
        return self
    }
    
    
    /**
     Set the font of the subtitle for all items.
     */
    @discardableResult public func setSubtitleFontForAllItems(_ font: UIFont) -> GTSheetMenuView {
        configuration.subtitleFont = font
        return self
    }
    
    
    /**
     Set the subtitle font for the item at the given index.
     */
    @discardableResult public func setSubtitleFont(at index: Int, font: UIFont) -> GTSheetMenuView {
        configuration.specificSubtitleFont.append((index, font))
        return self
    }
    
    
    /**
     Set the alignment of the subtitle for all items.
     */
    @discardableResult public func setSubtitleAlignmentForAllItems(_ alignment: NSTextAlignment) -> GTSheetMenuView {
        configuration.subtitleAlignment = alignment
        return self
    }
    
    
    /**
     Set the subtitle text alignment for the item at the given index.
     */
    @discardableResult public func setSubtitleAlignment(at index: Int, alignment: NSTextAlignment) -> GTSheetMenuView {
        configuration.specificSubtitleAlignment.append((index, alignment))
        return self
    }
    
    
    // MARK: - Overlay
    
    /**
     Set a custom background color for the overlay view.
     */
    @discardableResult public func setOverlayColor(_ color: UIColor) -> GTSheetMenuView {
        configuration.overlayColor = color
        return self
    }

    
    /**
     Disable dismissing the sheet menu view by tapping on the overlay view.
     
     By default, sheet menu view is dismissed when the overlay view is tapped.
     */
    @discardableResult public func disableSheetMenuDismissalOnOverlayTap() -> GTSheetMenuView {
        configuration.dismissOnTap = false
        return self
    }
    
    
    // MARK: - Set Menu Items
    
    /**
     Provide the items to display as a collection of `GTSheetMenuItemInfo` elements.
     */
    @discardableResult public func set(items: [GTSheetMenuItemInfo]) -> GTSheetMenuView {
        self.items = items
        return self
    }
    
    
    // MARK: - Get Item & Item View
    
    /**
     Get the menu item view at the given index.
     
     - Parameter index: The index of the menu item view that should be returned.
     - Returns: A `GTSheetMenuItemView` object that represents the menu item view.
     */
    @discardableResult public func getItemView(at index: Int) -> GTSheetMenuItemView? {
        guard let itemsContainer = itemsContainer, index < itemsContainer.subviews.count else { return nil }
        return itemsContainer.subviews[index] as? GTSheetMenuItemView
    }
    
    
    /**
     Get the menu item at the given index as a `SheetMenuViewInfo` object.
     */
    @discardableResult public func getItemInfo(at index: Int) -> GTSheetMenuItemInfo? {
        guard index < items.count else { return nil }
        return items[index]
    }
    
    
    // MARK: - Item Selection
    
    /**
     Perform an action upon an item's selection.
     
     - Parameter action: The action handler (closure) to add any implementation
     when an item is tapped.
     - Parameter itemIndex: The index of the tapped item.
     */
    @discardableResult public func onItemSelection(_ action: @escaping (_ itemIndex: Int) -> Void) -> GTSheetMenuView {
        actionHandler = action
        return self
    }
    
    
    /**
     Set the selection color shown when an item is tapped.
     */
    @discardableResult public func setItemSelectionColor(_ color: UIColor) -> GTSheetMenuView {
        configuration.itemSelectionColor = color
        return self
    }
    
}
