//
//  GTSheetMenuConfiguration.swift
//

import UIKit

class GTSheetMenuConfiguration {
    
    // MARK: - Sheet View Width
    
    var sheetViewWidth: CGFloat?
    var horizontalPadding: HorizontalPadding?
    var sheetViewWidthForLayoutRules = [(width: CGFloat, layoutRules: LayoutRules)]()
    var horizontalPaddingForLayoutRules = [(horizontalPadding: HorizontalPadding, layoutRules: LayoutRules)]()
    
    
    // MARK: - Sheet View General
    
    var backgroundColor: UIColor
    var cornerRadius: CGFloat = 0.0
    var showSeparators = true
    var imageBeforeTitle = false
    var itemsContainerInsets = UIEdgeInsets(top: 8.0, left: 20.0, bottom: 20.0, right: 20.0)
    var itemSelectionColor: UIColor = .lightGray
    var centerContent = false
    
    
    // MARK: - Title
    
    var title: String?
    var titleTextColor: UIColor
    var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17.0)
    var titleAlignment: NSTextAlignment = .center
    
    
    // MARK: - Item Title
    
    var itemTitleFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var specificTitleFont = [(itemIndex: Int, font: UIFont)]()
    var itemTitleTextColor: UIColor
    var specificTitleColor = [(itemIndex: Int, color: UIColor)]()
    var itemTitleAlignment: NSTextAlignment = .left
    var specificTitleAlignment = [(itemIndex: Int, alignment: NSTextAlignment)]()
    var titleLabelHeight: CGFloat = 24.0
    
    
    // Item ImageView
    
    var imageViewSize: CGSize = CGSize(width: 24.0, height: 24.0)
    var imageViewContentMode: UIView.ContentMode = .scaleAspectFit
    
    
    // MARK: - Subtitle
    
    var subtitleFont = UIFont.italicSystemFont(ofSize: UIFont.smallSystemFontSize)
    var specificSubtitleFont = [(itemIndex: Int, font: UIFont)]()
    var subtitleTextColor = UIColor.lightGray
    var specificSubtitleTextColor = [(itemIndex: Int, color: UIColor)]()
    var subtitleAlignment = NSTextAlignment.left
    var specificSubtitleAlignment = [(itemIndex: Int, alignment: NSTextAlignment)]()
    
    
    // MARK: - Items Height
    
    var itemsHeight: CGFloat = 50.0
    var specificItemHeight = [(itemIndex: Int, height: CGFloat)]()
    
    
    // MARK: - Overlay
    
    var overlayColor = UIColor(white: 0.25, alpha: 0.75)
    var dismissOnTap = true
    
    
    // MARK: - Init
    
    init() {
        if #available(iOS 13.0, *) {
            backgroundColor = UIColor.systemBackground
            itemTitleTextColor = UIColor.label
            titleTextColor = UIColor.label
        } else {
            backgroundColor = .white
            itemTitleTextColor = .black
            titleTextColor = .black
        }
    }
}
