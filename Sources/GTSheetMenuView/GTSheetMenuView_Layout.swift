//
//  GTSheetMenuView_Layout.swift
//

import UIKit

extension GTSheetMenuView {
    
    /**
     It applies the proper constraints to sheet view so it will be laid out
     properly to self respecting any layout related configuration.
     
     Initially it's checked if specific width should be applied for the
     current horizontal and vertical size class combination. If one
     is found the respective constraints are set.
     
     If no specific width is found, it checks if there's a horizontal padding
     provided for the current size class combination and it applies it if any found.
     
     Otherwise, it applies to sheet view any of the following in the order shown below:
     
     1. A general fixed width.
     2. A general horizontal padding.
     3. Default leading and trailing contraints.
     
     - SeeAlso:
     * `applyNonSizeClassSpecificConstraints()`
     * `updateSheetViewHorizontalPadding(with:)`
     * `applyNonSizeClassSpecificConstraints()`
     * `updateSheetViewWidth(with:)`
     */
    func layoutSheetView() {
        // Check if there is specific sheet view width set for the current
        // horizontal and vertical size class combination.
        guard configuration.sheetViewWidthForLayoutRules.count > 0 else {
            // No width for the current size classes.
            // Check if there's specific horizontal padding given for the current
            // size classes.
            guard configuration.horizontalPaddingForLayoutRules.count > 0 else {
                
                // No horizontal padding for the current size class combination.
                
                // Try to apply either any generic width or horizontal padding that might
                // have been specified, or set the original constraints.
                applyNonSizeClassSpecificConstraints()
                return
            }
            
            // Horizontal padding values for size class combinations were found.
            
            // Get padding values for the current size classes if they have been specified.
            if let padding = getHorizontalPaddingForLayoutRules() {
                // Update sheet view constraints.
                updateSheetViewHorizontalPadding(with: padding)
            } else {
                // No horizontal padding values for the current size class combination.
                
                // Try to apply either any generic width or horizontal padding that might
                // have been specified, or set the original constraints.
                applyNonSizeClassSpecificConstraints()
            }
            
            return
        }
        
        // Try to get the width for the current size class combination.
        if let widthForLayoutRules = getWidthForLayoutRules() {
            // Specific width for the current size class combination exists.
            // Update sheet view constraints using it.
            updateSheetViewWidth(with: widthForLayoutRules)
        } else {
            // No width for the current size class combination.
            
            // Try to apply either any generic width or horizontal padding that might
            // have been specified, or set the original constraints.
            applyNonSizeClassSpecificConstraints()
        }
    }
        
    
    /**
     Get the width for the current horizontal and vertical size class combination.
     
     Width is looked up in the `sheetViewWidthForLayoutRules` collection of the
     `configuration` object.
     
     - Returns: The width for the given combination of size classes, or `nil` if
     none is found.
     */
    func getWidthForLayoutRules() -> CGFloat? {
        let currentHorizontalSizeClass = UIScreen.main.traitCollection.horizontalSizeClass
        let currentVerticalSizeClass = UIScreen.main.traitCollection.verticalSizeClass
        
        guard let widthForLayoutRules = configuration.sheetViewWidthForLayoutRules.filter({
            $0.layoutRules.horizontalSizeClass == currentHorizontalSizeClass &&
            $0.layoutRules.verticalSizeClass == currentVerticalSizeClass }
        ).first?.width else { return nil }
        
        return widthForLayoutRules
    }
    
    
    /**
     Get the horizontal padding values for the current horizontal and vertical size class combination.
     
     Horizontal padding is looked up in the `horizontalPaddingForLayoutRules` collection of the
     `configuration` object.
     
     - Returns: The horizontal padding as a `HorizontalPadding` value, or `nil` if none is found
     for the current size class combination.
     */
    func getHorizontalPaddingForLayoutRules() -> HorizontalPadding? {
        let currentHorizontalSizeClass = UIScreen.main.traitCollection.horizontalSizeClass
        let currentVerticalSizeClass = UIScreen.main.traitCollection.verticalSizeClass
        
        guard let padding = configuration.horizontalPaddingForLayoutRules.filter({
            $0.layoutRules.horizontalSizeClass == currentHorizontalSizeClass &&
            $0.layoutRules.verticalSizeClass == currentVerticalSizeClass}
        ).first?.horizontalPadding else { return nil }
        
        return padding
    }
    
    
    /**
     It applies a general width to sheet view if specified, otherwise a horizontal padding
     if specified too, or the default leading and trailing constraints if none of the
     previous two was provided.
     */
    func applyNonSizeClassSpecificConstraints() {
        // Try to apply specific width to sheet view if it was provided.
        if !setSheetViewWidth() {
            // No specific width for the sheet view.
            // Check if there's horizontal padding to apply (leading and
            // trailing anchors with constant values).
            if !setSheetViewHorizontalPadding() {
                // No padding.
                // Apply the original leading and trailing anchor constraints.
                applyOriginalHorizontalConstraints()
            }
        }
    }
        
    
    /**
     It updates the sheet view autolayout constraints using the width
     specified to the `sheetViewWidth` property of the
     `configuration` object.
     */
    func setSheetViewWidth() -> Bool {
        if let width = configuration.sheetViewWidth {
            updateSheetViewWidth(with: width)
            return true
        }
        return false
    }
    
    
    /**
     It updates the sheet view autolayout constraints by setting
     any leading and trailing padding specified in the `horizontalPadding`
     property of the `configuration` object.
     
     Autolayout constraints update takes place in the
     `updateSheetViewHorizontalPadding(with:)` method.
     */
    func setSheetViewHorizontalPadding() -> Bool {
        if let padding = configuration.horizontalPadding {
            updateSheetViewHorizontalPadding(with: padding)
            return true
        }
        return false
    }
    
    
    /**
     It removes any of the leading, trailing and centerX constraints
     regarding the sheet view from self, and the width constraint
     from the sheet view itself in case it exists.
     */
    func removeSheetViewConstraints() {
        guard let sheetView = sheetView else { return }
        
        // Search for and remove any existing leading, trailing and centerX constraint
        // regarding sheet view from self.
        self.constraints.forEach { (constraint) in
            if let firstItem = constraint.firstItem, firstItem.isKind(of: SheetView.self) {
                if constraint.firstAnchor == sheetView.leadingAnchor ||
                    constraint.firstAnchor == sheetView.trailingAnchor ||
                    constraint.firstAnchor == sheetView.centerXAnchor {
                    self.removeConstraint(constraint)
                }
            }
        }
                
        // Search for and remove the width constraint if exists from the sheet view.
        sheetView.constraints.forEach { (constraint) in
            if constraint.firstAnchor == sheetView.widthAnchor {
                sheetView.removeConstraint(constraint)
            }
        }
    }
    
    
    /**
     It applies the original leading and trailing constraints
     by aligning the leading and trailing anchors of sheet view and self.
     */
    func applyOriginalHorizontalConstraints() {
        removeSheetViewConstraints()
        sheetView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        sheetView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
        
    
    /**
     It updates the constraints of the sheet view so it's using the given width
     centered horizontally.
     
     - Parameter width: The width constraint to apply.
     
     - Note: Any previous leading, trailing, width and centerX constraints regarding
     the sheet view are removed.
     */
    func updateSheetViewWidth(with width: CGFloat) {
        removeSheetViewConstraints()
        
        // Add the width constraint using the given width and center it horizontally.
        sheetView?.widthAnchor.constraint(equalToConstant: width).isActive = true
        sheetView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    
    /**
     It updates the constraints of the sheet view so it's using the given
     leading and trailing padding.
     
     - Parameter padding: A `HorizontalPadding` value describing the leading
     and trailing padding.
     */
    func updateSheetViewHorizontalPadding(with padding: HorizontalPadding) {
        removeSheetViewConstraints()
        
        // Add the leading and trailing anchor constraints applying any padding respectively.
        sheetView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding.leading).isActive = true
        sheetView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: padding.trailing).isActive = true
    }
    
    
    /**
     It updates the height constraint of the sheet view so it can fit
     the title label.
     
     Additional height given for the title label is 40pt.
     */
    func updateHeightForTitle() {
        guard let sheetView = sheetView else { return }
        
        // Find the height constraint in sheet view constraints.
        guard let heightConstraint = sheetView.constraints.filter({ $0.firstAnchor == sheetView.heightAnchor }).first
            else { return }
        
        // Get its index in the constraints collection.
        guard let index = sheetView.constraints.firstIndex(of: heightConstraint) else { return }
        
        // Update its constant.
        sheetView.constraints[index].constant += 40.0
    }
    
    
    /**
     It updates the sheet view height constraint so it fits all items and
     the title label if necessary, considering the items container view top and
     bottom insets.
     */
    func updateSheetViewHeight() {
        guard let sheetView = sheetView else { return }
        guard let heightConstraint = sheetView.constraints.filter({ $0.firstAnchor == sheetView.heightAnchor }).first
            else { return }
        
        let height = calculateItemsHeight() + 30.0 +
            configuration.itemsContainerInsets.top + configuration.itemsContainerInsets.bottom +
            (titleLabel != nil ? 40.0 : 0.0)
        heightConstraint.constant = height
    }
}
