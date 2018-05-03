//
//  AppAppearance.swift
//  Jamahook
//
//  Created by Towhid on 11/18/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import UIKit
import CoreDataStack

struct StaticColorBank {
    
    static var viewBackgroundColor = UIColor.white
    static var evenCellColor = UIColor.white
    static var oddCellColor = ColorBank.color(fromHexString: "#fafafa")
    static var HoxroBrandColor = ColorBank.color(fromHexString: "#00457e")
    static var HoxroNavBarColor = ColorBank.color(fromHexString: "#4285f4")
    
    static var buttonColor = ColorBank.color(fromHexString: "#00457e")
    static var buttonDisabledTitleColor = ColorBank.color(fromHexString: "#5ed9c1")
    static var buttonTitleColor = UIColor.white
    
    static var titleColor = UIColor.white //ColorBank.colorFromHexString("#00457e")
    static var textColorOnWhiteBG = ColorBank.color(fromHexString: "#707070")
    static var textBoxBorderColor = ColorBank.color(fromHexString: "#707070")
    static var textBoxErrorBorderColor = ColorBank.color(fromHexString: "#d71743")
    static var timerDisplayColor = UIColor.white//ColorBank.colorFromHexString("#60254c")
    static var timerDisplayBGColor = ColorBank.color(fromHexString: "#677381")//UIColor.whiteColor()
    static var recorderViewBGColor = UIColor.white
    //static var viewBackgroundColor = ColorBank.colorFromHexString("#d9dcdd")
    
    static var seekBarColor = ColorBank.color(fromHexString: "#e39924")
    static var seekBarTintColor = ColorBank.color(fromHexString: "#1f253d")
    static var seekBarViewColor = ColorBank.color(fromHexString: "#394264")
    
    static var playerViewColor = seekBarTintColor
    static var playerTitleColor = UIColor.black.withAlphaComponent(0.60)
    static var progressBGColor = ColorBank.color(fromHexString: "#d1d1d1")
    static var progressColor = ColorBank.color(fromHexString: "#60254c")
    static var progressCacnelColor = UIColor.red
    
    static var tabItemTitleColor = UIColor.white
    static var tabItemTitleSelectColor = ColorBank.color(fromHexString: "#0aa89e")
    
    static var tabBarTintColor = ColorBank.color(fromHexString: "#411432")
    static var tabBarItemTintColor = ColorBank.color(fromHexString: "#0aa89e")
    
    static var navBarTintColor = HoxroNavBarColor //ColorBank.colorFromHexString("#4A2251")
    static var navBarItemTintColor = UIColor.white //ColorBank.colorFromHexString("#0aa89e")
    
    static var renameCellActionColor = ColorBank.color(fromHexString: "#1abc9c")
    static var deleteCellActionColor = UIColor.orange
}

open class AppAppearance: NSObject{
    
    open class func initAppearance(){
        NavigationBar.Color()
        NavigationBar.ItemTintColor()
        NavigationBar.Title()
        //TabBar.Color()
        //TabBar.TintColor()
        //TabBar.ItemsTitleColor()
        //SearchBar.Color()
    }
}

open class SearchBar: NSObject{
    
    class func Color(_ bar: UISearchBar){
        bar.searchBarStyle = UISearchBarStyle.prominent
        bar.barTintColor = StaticColorBank.HoxroBrandColor
        bar.tintColor = UIColor.white
    }
    
    class func ChangeTextAppearance(_ bar: UISearchBar, text: String = ""){
        bar.placeholder = text
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = StaticColorBank.HoxroBrandColor
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = StaticColorBank.HoxroBrandColor
    }
    
    fileprivate class func getAttributes(_ text: String, color: UIColor) -> NSAttributedString{
        let attribute = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: text, options: NSString.CompareOptions.caseInsensitive)
        attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        return attribute
    }
}

open class NavigationBar: NSObject{
    
    class func Color(){
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = StaticColorBank.navBarTintColor
    }
    
    class func ItemTintColor(){
        UINavigationBar.appearance().tintColor = StaticColorBank.navBarItemTintColor
    }
    
    class func Title(){
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:StaticColorBank.titleColor
            , NSAttributedStringKey.font: FontConfig.defaultFont(style: FontStyle.Medium, size: 15.0)]
    }
    
}

open class TabBar: NSObject{
    
    class func Color(){
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = StaticColorBank.tabBarTintColor
        UITabBar.appearance().backgroundImage = UIImage(catalog: AssetCatalog.tabBarBackground)
    }
    
    class func TintColor(){
        UITabBar.appearance().tintColor = StaticColorBank.tabBarItemTintColor
        let tabIndicator = UIImage(catalog: AssetCatalog.tabBarSelectionIndicator)?.withRenderingMode(.alwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
    }
    
    class func ItemsTitleColor(){
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -4.0)
        UITabBarItem.appearance().setTitleTextAttributes([ NSAttributedStringKey.font: FontConfig.defaultFont(style: FontStyle.Bold, size: 11.0), NSAttributedStringKey.foregroundColor: StaticColorBank.tabItemTitleColor], for: UIControlState())
        UITabBarItem.appearance().setTitleTextAttributes([ NSAttributedStringKey.font: FontConfig.defaultFont(style: FontStyle.Bold, size: 11.0),NSAttributedStringKey.foregroundColor: StaticColorBank.tabItemTitleSelectColor!], for: UIControlState.selected)
    }
}

open class Slider: NSObject{
    
    class func Appearance(activateOn classTypes: [AnyObject.Type]? = nil){
        let minImg = UIImage(catalog: AssetCatalog.sliderMin).resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5, 0, 0))
        let maxImg = UIImage(catalog: AssetCatalog.sliderMax).resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5, 0, 0))
        let thumb = UIImage(catalog: AssetCatalog.sliderThumbNail)
        if classTypes == nil{
            UISlider.appearance().setMaximumTrackImage(maxImg, for: UIControlState())
            UISlider.appearance().setMinimumTrackImage(minImg, for: UIControlState())
            UISlider.appearance().setThumbImage(thumb, for: UIControlState())
            UISlider.appearance().setThumbImage(thumb, for: UIControlState.highlighted)
        }
        else{
            UISlider.appearance(whenContainedInInstancesOf: classTypes! as! [UIAppearanceContainer.Type]).setMaximumTrackImage(maxImg, for: UIControlState())
            UISlider.appearance(whenContainedInInstancesOf: classTypes! as! [UIAppearanceContainer.Type]).setMinimumTrackImage(minImg, for: UIControlState())
            UISlider.appearance(whenContainedInInstancesOf: classTypes! as! [UIAppearanceContainer.Type]).setThumbImage(thumb, for: UIControlState())
            UISlider.appearance(whenContainedInInstancesOf: classTypes! as! [UIAppearanceContainer.Type]).setThumbImage(thumb, for: UIControlState.highlighted)
        }
    }
    
}

open class SegmentControl: NSObject{
    
    class func Appearance(activateOn classTypes: [AnyObject.Type]? = nil){
        if classTypes == nil{
            UISegmentedControl.appearance().tintColor = StaticColorBank.buttonColor
        }
        else{
            UISegmentedControl.appearance(whenContainedInInstancesOf: classTypes! as! [UIAppearanceContainer.Type]).tintColor = StaticColorBank.buttonColor
        }
    }
    
}

open class Button: NSObject{
    
    class func Appearance(_ sender: UIButton){
        View.Carv(sender)
        sender.backgroundColor = StaticColorBank.buttonColor
        sender.tintColor = StaticColorBank.buttonColor
        sender.setTitleColor(StaticColorBank.buttonTitleColor, for: UIControlState())
        sender.setTitleColor(StaticColorBank.buttonTitleColor, for: UIControlState.selected)
    }
    
    class func DeleteAppearance(_ sender: UIButton){
        View.Carv(sender)
        sender.backgroundColor = UIColor.red
        sender.tintColor = StaticColorBank.buttonColor
        sender.setTitleColor(StaticColorBank.buttonTitleColor, for: UIControlState())
        sender.setTitleColor(StaticColorBank.buttonTitleColor, for: UIControlState.selected)
    }
    
    class func TitleAppearance(_ sender: UIButton){
        //TODO:
    }
    
}

open class View: NSObject{
    
    class func Carv(_ sender: UIView, by value: CGFloat = 2.5){
        let layer = sender.layer
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    class func Border(_ sender: UIView, color: UIColor, width: CGFloat = 1.5){
        let layer = sender.layer
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    @available(iOS 8.0, *)
    class func createVisualEffect(_ frame: CGRect, style: UIBlurEffectStyle = UIBlurEffectStyle.dark) -> UIVisualEffectView{
        let blurEfect = UIBlurEffect(style: style)
        let visualEffectView = UIVisualEffectView(effect: blurEfect)
        visualEffectView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        visualEffectView.frame = frame
        return visualEffectView
    }
}

open class Text: NSObject{
    
    class func dynamicSize(_ text: NSString, font: UIFont, maxSize: CGSize? = nil) -> CGSize{
        let availableSize: CGSize = (maxSize != nil) ? maxSize! : CGSize(width: CGFloat(320.0), height: CGFloat(MAXFLOAT))
        let size: CGSize = text.boundingRect(with: availableSize
            , options: NSStringDrawingOptions.usesLineFragmentOrigin
            , attributes: [NSAttributedStringKey.font: font]
            , context: nil).size
        return size
    }
    
}

