//
//  FontConfig.swift
//  MymoUpload
//
//  Created by Towhid on 9/7/14.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import UIKit

enum FontStyle: String{
    case Light = "-Light"
    case Regular = "-Regular"
    case Medium = "-Medium"
    case Normal = "-Normal"
    case Bold = "-Bold"
    case Italic = "-Italic"
}

class FontConfig: NSObject {
    
    class var fontSizeRatio: CGFloat{
        get{
            if UIScreen.mainScreen().scale >= 3.0 {
                return CGFloat(1.4)
            }
            else{
                return CGFloat(1.0)
            }
        }
    }
    
    private struct StaticFontFamilyName  {
        
        static var Helvetica = "Helvetica"
        static var Lato = "Lato"
        static var Chalkduster = "Chalkduster"
        static var Exo = "Exo"
    }
    
    class func defaultFont(style fontStyle: FontStyle, size: CGFloat) -> UIFont{
        
        let fname = FontConfig.defaultFontName(style: fontStyle)
        return UIFont(name: fname, size: size)!
    }
    
    class func defaultFontName(style fontStyle: FontStyle) -> String{
        
        return evaluateFontName(StaticFontFamilyName.Exo, fontStyle: fontStyle)
    }
    
    private final class func evaluateFontName(name: String, fontStyle: FontStyle) -> String{
        let fontName = (name as NSString).stringByReplacingOccurrencesOfString(" ", withString: "") + fontStyle.rawValue
        //safty checking for available font style
        let fontStyles: NSArray = UIFont.fontNamesForFamilyName(name) as NSArray
        if fontStyles.count > 0{
            let isExist: Bool = fontStyles.containsObject(fontName)
            var finalFontName: String = fontName
            if !isExist{
                finalFontName = fontStyles.firstObject as! String!
                NSLog("\(fontName) is not available. So for consistancy \(finalFontName) has been randered.")
            }
            return finalFontName
        }else{
            fatalError("\(fontName) is not available. So we crash here :$")
        }
        return ""
    }
}


