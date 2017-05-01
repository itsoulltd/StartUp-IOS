//
//  UIImage+Rokomari.swift
//  RokomariReader
//
//  Created by Towhid Islam on 10/25/16.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import UIKit

extension UIImage{
    
    convenience init!(catalog: AssetCatalog) {
        self.init(named: catalog.rawValue)
    }
    
    func resize(size:CGSize, at scale:CGFloat) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        drawInRect(CGRectMake(0, 0, size.width, size.height))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage!
    }
    
}
