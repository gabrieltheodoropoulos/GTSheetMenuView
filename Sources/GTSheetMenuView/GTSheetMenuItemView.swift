//
//  GTSheetMenuItemView.swift
//

import UIKit

public class GTSheetMenuItemView: UIView {
    
    // MARK: - Public Properties
    
    public var title: UILabel?
    
    public var subtitle: UILabel?
    
    public var imageView: UIImageView?
    
    public var separator: UIView?
    
    
    // MARK: - Internal Properties
    
//    let imageViewHeight: CGFloat = 24.0
    
    let titleImageViewSpacing: CGFloat = 8.0
    
    var index: Int?
    
    var selectionColor: UIColor?
    
    var bgColor: UIColor?
    
    
    
    // MARK: - Configuration
    
    /**
     Initialize and configure a menu item.
     
     - Parameter height: The height of the item.
     - Parameter parentView: The items container view that the item view
     will be added as a subview to.
     - Parameter index: The index of the current item among all items.
     - Parameter itemsTotalHeight: The total height of all previous items so it's
     possible to layout current item properly.
     - Parameter tapTarget: The target of the tap action on the item.
     - Parameter action: The action to trigger on tap.
     - Parameter selectionColor: The selection color shown when the item is tapped.
     
     - Returns: An initialized `GTSheetMenuItemView` object.
     */
    class func initializeItemView(withHeight height: CGFloat, parentView: UIView, index: Int, itemsTotalHeight: CGFloat,
                                  tapTarget: GTSheetMenuView, action: Selector,
                                  selectionColor: UIColor) -> GTSheetMenuItemView {
        let view = GTSheetMenuItemView()
        parentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0.0).isActive = true
        view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 0.0).isActive = true
        view.topAnchor.constraint(equalTo: parentView.topAnchor, constant: itemsTotalHeight).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        // Add a tap gesture recognizer to the view.
        view.addGestureRecognizer(UITapGestureRecognizer(target: tapTarget, action: action))
        
        // Keep the view index.
        view.index = index
        
        // Keep the selection color.
        view.selectionColor = selectionColor
        
        return view
    }
    
    
    /**
     It initializes and lays out the title label and imageview of self item as necessary.
     
     - Parameter itemInfo: A `GTSheetMenuItemInfo` object that contains the title, image and subtitle
     of the item. It's necessary to determine whether imageview should be initialized or not.
     - Parameter showImageBeforeTitle: A flag that determines whether imageview should be displayed
     on the left or the right side of the title label.
     - Parameter showSeparator: A flag that indicates whether separator view should be added or not
     to the item.
     
     - Returns: An updated `GTSheetMenuItemView` instance.
     */
    @discardableResult
    func configureItem(with itemInfo: GTSheetMenuItemInfo, configuration: GTSheetMenuConfiguration, maxTitleWidth: CGFloat) -> GTSheetMenuItemView {
        // Initialize the title label, add it to self and setup constraints that
        // do not depend on the showImageBeforeTitle flag.
        title = UILabel()
        title?.text = itemInfo.title
        title?.textColor = configuration.specificTitleColor.filter({ $0.itemIndex == index }).first?.color ?? configuration.itemTitleTextColor
        title?.font = configuration.specificTitleFont.filter({ $0.itemIndex == index }).first?.font ?? configuration.itemTitleFont
        title?.textAlignment = configuration.specificTitleAlignment.filter({ $0.itemIndex == index }).first?.alignment ?? configuration.itemTitleAlignment
        self.addSubview(title!)
        title?.translatesAutoresizingMaskIntoConstraints = false
        title?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
        title?.heightAnchor.constraint(equalToConstant: configuration.titleLabelHeight).isActive = true
        
        // Make sure that there's an image to show otherwise imageview
        // won't be initialized.
        if let image = itemInfo.image {
            // Initialize the imageview, add it to self and setup constraints
            // that do not depend on the showImageBeforeTitle flag.
            imageView = UIImageView()
            imageView?.image = image
            imageView?.contentMode = configuration.imageViewContentMode
            self.addSubview(imageView!)
            imageView?.translatesAutoresizingMaskIntoConstraints = false
            imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0.0).isActive = true
            imageView?.widthAnchor.constraint(equalToConstant: configuration.imageViewSize.width).isActive = true
            imageView?.heightAnchor.constraint(equalToConstant: configuration.imageViewSize.height).isActive = true
            
            if !configuration.centerContent {
                // Add any missing constraints from the title label and the imageview depending on
                // whether imageview should be shown before or after the title label.
                if configuration.imageBeforeTitle {
                    imageView?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
                    title?.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: titleImageViewSpacing).isActive = true
                    title?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
                } else {
                    imageView?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
                    title?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
                    title?.trailingAnchor.constraint(equalTo: imageView!.leadingAnchor, constant: -titleImageViewSpacing).isActive = true
                }
            } else {
                // Center content.
                // For that purpose use a container view that will contain
                // the title and the image view.
                
                let totalWidth = configuration.imageViewSize.width + titleImageViewSpacing + maxTitleWidth
                
                let containerView = UIView()
                containerView.backgroundColor = .clear
                self.addSubview(containerView)
                containerView.translatesAutoresizingMaskIntoConstraints = false
                containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
                containerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                containerView.widthAnchor.constraint(equalToConstant: totalWidth).isActive = true
                containerView.heightAnchor.constraint(equalToConstant: max(configuration.titleLabelHeight, configuration.imageViewSize.height)).isActive = true
                
                title?.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                title?.widthAnchor.constraint(equalToConstant: maxTitleWidth).isActive = true
                
                imageView?.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                imageView?.widthAnchor.constraint(equalToConstant: configuration.imageViewSize.width).isActive = true
                imageView?.heightAnchor.constraint(equalToConstant: configuration.imageViewSize.height).isActive = true
                
                if configuration.imageBeforeTitle {
                    imageView?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                    title?.leadingAnchor.constraint(equalTo: imageView!.trailingAnchor, constant: titleImageViewSpacing).isActive = true
                } else {
                    title?.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
                    imageView?.leadingAnchor.constraint(equalTo: title!.trailingAnchor, constant: titleImageViewSpacing).isActive = true
                }
            }
        } else {
            // No imageview.
            if !configuration.centerContent {
                // Set the leading and trailing anchors of title label.
                title?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
                title?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
            } else {
                title?.widthAnchor.constraint(equalToConstant: title?.sizeThatFits(.zero).width ?? 0.0).isActive = true
                title?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            }
        }
        
        
        // Configure the separator view if necessary.
        if configuration.showSeparators {
            configureSeparator()
        }
        
        return self
    }
        
    
    
    /**
     It initializes and configures the subtitle label using the provided configuration.
     */
    @discardableResult
    func configureSubtitle(using configuration: GTSheetMenuConfiguration, subtitleText: String?)-> GTSheetMenuItemView {
        guard let title = title, let text = subtitleText else { return self }
        subtitle = UILabel()
        subtitle?.backgroundColor = .yellow
        subtitle?.text = text
        subtitle?.textColor = configuration.subtitleTextColor
        subtitle?.font = configuration.specificSubtitleFont.filter({ $0.itemIndex == index }).first?.font ?? configuration.subtitleFont
        subtitle?.textAlignment = configuration.specificSubtitleAlignment.filter({ $0.itemIndex == index }).first?.alignment ?? configuration.subtitleAlignment
        self.addSubview(subtitle!)
        subtitle?.translatesAutoresizingMaskIntoConstraints = false
        
        if !configuration.centerContent {
            subtitle?.leadingAnchor.constraint(equalTo: title.leadingAnchor, constant: 0.0).isActive = true
            subtitle?.trailingAnchor.constraint(equalTo: title.trailingAnchor, constant: 0.0).isActive = true
        } else {
            subtitle?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0).isActive = true
            subtitle?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0).isActive = true
        }
        
        subtitle?.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4.0).isActive = true
        subtitle?.heightAnchor.constraint(equalToConstant: subtitle!.sizeThatFits(.zero).height).isActive = true
        return self
    }
    
    
    /**
     It initializes and configures the separator view.
     */
    fileprivate func configureSeparator() {
        separator = UIView()
        separator?.backgroundColor = .gray
        self.addSubview(separator!)
        separator?.translatesAutoresizingMaskIntoConstraints = false
        separator?.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        separator?.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true
        separator?.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        separator?.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
    
    
    // MARK: - Touches Override
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        bgColor = self.backgroundColor
        highlight()
    }
    
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        unhighlight()
    }
    
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        unhighlight()
    }
    
    
    // MARK: - Assistive Methods
    
    fileprivate func highlight() {
        self.backgroundColor = selectionColor
    }
    
    fileprivate func unhighlight() {
        self.backgroundColor = bgColor
    }
    
    
    class func getMaxTitleWidth(using itemInfo: [GTSheetMenuItemInfo], configuration: GTSheetMenuConfiguration) -> CGFloat {
        var maxWidth: CGFloat = 0.0
        
        for (index, info) in itemInfo.enumerated() {
            let label = UILabel()
            label.text = info.title
            label.textColor = configuration.specificTitleColor.filter({ $0.itemIndex == index }).first?.color ?? configuration.itemTitleTextColor
            label.font = configuration.specificTitleFont.filter({ $0.itemIndex == index }).first?.font ?? configuration.itemTitleFont
            label.textAlignment = configuration.specificTitleAlignment.filter({ $0.itemIndex == index }).first?.alignment ?? configuration.itemTitleAlignment
            
            let width = label.sizeThatFits(.zero).width
            if width > maxWidth {
                maxWidth = width
            }
        }
        
        return maxWidth
    }
}
