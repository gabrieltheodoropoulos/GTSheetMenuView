//
//  GTSheetMenuView.swift
//

import UIKit

open class GTSheetMenuView: UIView {
    
    // MARK: - Internal Properties
    
    var sheetView: SheetView?
    
    var overlayView: UIView?
    
    var titleLabel: UILabel?
    
    var itemsContainer: UIView?
    
    var parentView: UIView?
    
    var configuration = GTSheetMenuConfiguration()
    
    var items = [GTSheetMenuItemInfo]()
    
    var didDismissHandler: (() -> Void)?
    
    var actionHandler: ((_ itemIndex: Int) -> Void)?
    
    
    
    // MARK: - Init
    
    init(withParentView parentView: UIView) {
        super.init(frame: .zero)
        self.parentView = parentView
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    deinit {
        // print("Deinit in GTSheetMenuView!")
    }
    
    
    // MARK: - Handle Orientation Changes
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layoutSheetView()
    }
    
    
    // MARK: - Configuration
    
    fileprivate func configureSelf() {
        guard let parentView = parentView else { return }
        
        // Add self instance to parent view.
        parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
    
    
    fileprivate func configureOverlayView() {
        guard overlayView == nil else { return }
        
        // Initialize overlay view.
        overlayView = UIView()
        
        // Specify the background color of the overlay view.
        overlayView?.backgroundColor = configuration.overlayColor
        
        // Add a tap gesture recognizer if dismissing on tap is allowed.
        if configuration.dismissOnTap {
            overlayView?.isUserInteractionEnabled = true
            overlayView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnOverlayView(_:))))
        }
                
        // Turn off transparency initially.
        overlayView?.alpha = 0.0
        
        // Add overlay view to self and set its constraints.
        self.addSubview(overlayView!)
        overlayView?.translatesAutoresizingMaskIntoConstraints = false
        overlayView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        overlayView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        overlayView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        overlayView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
    fileprivate func configureSheetView() {
        guard sheetView == nil else { return }
        guard items.count > 0 else { return }
        
        // Initialize the sheet view.
        sheetView = SheetView()
        
        // Set the sheet view background color.
        sheetView?.backgroundColor = configuration.backgroundColor
        sheetView?.layer.cornerRadius = configuration.cornerRadius
        
        // Add sheet view to self.
        self.addSubview(sheetView!)
        sheetView?.translatesAutoresizingMaskIntoConstraints = false
        
        // Set autolayout constraints.
        
        // Set the bottom constraint.
        sheetView?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 30.0).isActive = true
        
        // Set sheet view height. 30pt are out of the visible area of the screen.
        let height: CGFloat = calculateItemsHeight() + 30.0 + configuration.itemsContainerInsets.top + configuration.itemsContainerInsets.bottom
        sheetView?.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        // Initially move the sheet view out of the visible area of the screen
        // towards bottom.
        sheetView?.transform = CGAffineTransform(translationX: 0.0, y: height)
    }
    
    
    func configureTitleLabel(with title: String) {
        guard let sheetView = sheetView else { return }
        titleLabel = UILabel()
        titleLabel?.text = title
        titleLabel?.textColor = configuration.titleTextColor
        titleLabel?.font = configuration.titleFont
        titleLabel?.textAlignment = configuration.titleAlignment
                
        sheetView.addSubview(titleLabel!)
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        titleLabel?.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: 4.0).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: 4.0).isActive = true
        titleLabel?.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: 8.0).isActive = true
        titleLabel?.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
    }
    
    
    
    func configureItemsContainer() {
        guard let sheetView = sheetView else { return }
        itemsContainer = UIView()
        itemsContainer?.backgroundColor = .orange
        
        sheetView.addSubview(itemsContainer!)
        itemsContainer?.translatesAutoresizingMaskIntoConstraints = false
        itemsContainer?.leadingAnchor.constraint(equalTo: sheetView.leadingAnchor, constant: configuration.itemsContainerInsets.left).isActive = true
        itemsContainer?.trailingAnchor.constraint(equalTo: sheetView.trailingAnchor, constant: -configuration.itemsContainerInsets.right).isActive = true
        itemsContainer?.topAnchor.constraint(equalTo: sheetView.topAnchor, constant: titleLabel == nil ?
            configuration.itemsContainerInsets.top :
            configuration.itemsContainerInsets.top + 40.0).isActive = true
        
        itemsContainer?.heightAnchor.constraint(equalToConstant: calculateItemsHeight()).isActive = true
    }
    
    
    // MARK: - Assistive Methods
    
    func getItemHeight(at index: Int) -> CGFloat {
        guard items.count > 0 else { return 0.0 }
        
        // Check if there's a specific height given for the current index.
        // If so, keep it as the item's height, otherwise use the global item height
        // specified in the configuration object.
        var height = (configuration.specificItemHeight.filter({ $0.itemIndex == index }).first?.height ?? configuration.itemsHeight)
        
        // Check if the current item has a subtitle.
        // If that's true, then calculate the additional height needed taking
        // into account either a font specified for the subtitle of this item,
        // or the global subtitle font specified in the configuration object.
        if let subtitle = items[index].subtitle {
            let label = UILabel()
            label.text = subtitle
            label.font = configuration.specificSubtitleFont.filter({ $0.itemIndex == index }).first?.font ?? configuration.subtitleFont
            height += 2.0 * label.sizeThatFits(.zero).height
        }
        
        // Eventually return the item's height.
        return height
    }
    
    
    func calculateItemsHeight() -> CGFloat {
        guard items.count > 0 else { return 0.0 }
        
        var height: CGFloat = 0.0
        for (index, _) in items.enumerated() {
            height += getItemHeight(at: index)
        }
        
        return height
    }
        
    
    func prepareToShow() -> Bool {
        guard items.count > 0, itemsContainer == nil else { return false }
        
        // Configure the overlay view.
        configureOverlayView()
        
        // Configure the sheet view.
        configureSheetView()
                
        // Configure the title label if a title has been provided.
        if let title = configuration.title {
            // Update the height of the sheet view so it fits the title label.
            updateHeightForTitle()
            
            // Configure title label.
            configureTitleLabel(with: title)
        }
        
        
        // Call this before the sheet view appears so any layout related
        // configuration to be applied.
        self.layoutSheetView()
        
        
        // Make sure to update the sheet view height in case items container
        // insets have been overriden.
        self.updateSheetViewHeight()
        
        
        // Initialize the items container view.
        configureItemsContainer()
        
        // Initialize and configure menu items.
        guard let itemsContainer = itemsContainer else { return false }
        
        // Find the max width of all titles in case content should be centered.
        let maxWidth: CGFloat = configuration.centerContent ?
            GTSheetMenuItemView.getMaxTitleWidth(using: items, configuration: configuration) : 0.0
        
        var itemsTotalHeight: CGFloat = 0.0
        for (index, info) in items.enumerated() {
            let height = getItemHeight(at: index)
            GTSheetMenuItemView.initializeItemView(withHeight: height, parentView: itemsContainer, index: index, itemsTotalHeight: itemsTotalHeight,
                                                 tapTarget: self, action: #selector(handleTapOnMenuItem(_:)), selectionColor: configuration.itemSelectionColor)
                .configureItem(with: info, configuration: configuration, maxTitleWidth: maxWidth)
                .configureSubtitle(using: configuration, subtitleText: info.subtitle)
            
            itemsTotalHeight += height
        }
        
        return true
    }
        
    
    func dismissAnimated(duration: TimeInterval = 0.25) {
        UIView.animate(withDuration: duration, animations: {
            self.overlayView?.alpha = 0.0
            self.sheetView?.transform = CGAffineTransform(translationX: 0.0, y: self.sheetView?.frame.size.height ?? UIScreen.main.bounds.size.height)
        }) { (_) in
            self.didDismissHandler?()
            self.cleanUp()
        }
    }
    
    
    func cleanUp() {
        overlayView?.removeFromSuperview()
        overlayView = nil
        sheetView?.removeFromSuperview()
        sheetView = nil
        parentView = nil
        didDismissHandler = nil
        self.removeFromSuperview()
    }
    
    
    // MARK: - Action Methods
    
    @objc
    fileprivate func handleTapOnOverlayView(_ gesture: UITapGestureRecognizer) {
        dismissAnimated()
    }
    
    
    @objc
    func handleTapOnMenuItem(_ gesture: UITapGestureRecognizer) {
        guard let index = (gesture.view as? GTSheetMenuItemView)?.index else { return }
        actionHandler?(index)
    }
    
    
    // MARK: - Class Methods
    
    /**
     Create and add a sheet menu view to a view.
     
     - Parameter parentView: The view that the sheet menu view will be added as a subview to.
     - Returns: A `GTSheetMenuView` instance that can be further configured.
     */
    public class func addSheetMenuView(to parentView: UIView) -> GTSheetMenuView {
        let menuView = GTSheetMenuView(withParentView: parentView)
        
        // Configure contained views.
        menuView.configureSelf()
                
        return menuView
    }
    
    
    
    /**
     Hide and remove a sheet menu view instance animated.
     
     `duration` is optional. If not provided animation will last 0.25 seconds
     by default.
     
     - Parameter view: The view that contains the sheet menu view as a subview.
     - Parameter duration: The dismiss animation duration. Default value is 0.25 seconds.
     */
    public class func hideAnimated(from view: UIView, duration: TimeInterval = 0.25) {
        // Find the sheet menu view in the subviews of the given view.
        guard let sheetMenuView = view.subviews.filter({ $0.isKind(of: GTSheetMenuView.self) }).first as? GTSheetMenuView else { return }
        
        // Dismiss it animated.
        sheetMenuView.dismissAnimated(duration: duration)
    }
}
