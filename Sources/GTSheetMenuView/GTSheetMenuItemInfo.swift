//
//  GTSheetMenuItem.swift
//

import UIKit

public struct GTSheetMenuItemInfo {
    public var title: String?
    public var subtitle: String?
    public var image: UIImage?
    
    public init(title: String, subtitle: String?, image: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
}
