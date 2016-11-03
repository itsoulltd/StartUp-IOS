//
//  AppAppearance.swift
//  Jamahook
//
//  Created by Towhid on 11/18/15.
//  Copyright © 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import UIKit
import SeliseToolKit

struct StaticColorBank {
    
    static var viewBackgroundColor = UIColor.whiteColor()
    static var evenCellColor = UIColor.whiteColor()
    static var oddCellColor = ColorBank.colorFromHexString("#fafafa")
    static var HoxroBrandColor = ColorBank.colorFromHexString("#00457e")
    static var HoxroNavBarColor = ColorBank.colorFromHexString("#4285f4")
    
    static var buttonColor = ColorBank.colorFromHexString("#00457e")
    static var buttonDisabledTitleColor = ColorBank.colorFromHexString("#5ed9c1")
    static var buttonTitleColor = UIColor.whiteColor()
    
    static var titleColor = UIColor.whiteColor() //ColorBank.colorFromHexString("#00457e")
    static var textColorOnWhiteBG = ColorBank.colorFromHexString("#707070")
    static var textBoxBorderColor = ColorBank.colorFromHexString("#707070")
    static var textBoxErrorBorderColor = ColorBank.colorFromHexString("#d71743")
    static var timerDisplayColor = UIColor.whiteColor()//ColorBank.colorFromHexString("#60254c")
    static var timerDisplayBGColor = ColorBank.colorFromHexString("#677381")//UIColor.whiteColor()
    static var recorderViewBGColor = UIColor.whiteColor()
    //static var viewBackgroundColor = ColorBank.colorFromHexString("#d9dcdd")
    
    static var seekBarColor = ColorBank.colorFromHexString("#e39924")
    static var seekBarTintColor = ColorBank.colorFromHexString("#1f253d")
    static var seekBarViewColor = ColorBank.colorFromHexString("#394264")
    
    static var playerViewColor = seekBarTintColor
    static var playerTitleColor = UIColor.blackColor().colorWithAlphaComponent(0.60)
    static var progressBGColor = ColorBank.colorFromHexString("#d1d1d1")
    static var progressColor = ColorBank.colorFromHexString("#60254c")
    static var progressCacnelColor = UIColor.redColor()
    
    static var tabItemTitleColor = UIColor.whiteColor()
    static var tabItemTitleSelectColor = ColorBank.colorFromHexString("#0aa89e")
    
    static var tabBarTintColor = ColorBank.colorFromHexString("#411432")
    static var tabBarItemTintColor = ColorBank.colorFromHexString("#0aa89e")
    
    static var navBarTintColor = HoxroNavBarColor //ColorBank.colorFromHexString("#4A2251")
    static var navBarItemTintColor = UIColor.whiteColor() //ColorBank.colorFromHexString("#0aa89e")
    
    static var renameCellActionColor = ColorBank.colorFromHexString("#1abc9c")
    static var deleteCellActionColor = UIColor.orangeColor()
}

public class AppAppearance: NSObject{
    
    public class func initAppearance(){
        NavigationBar.Color()
        NavigationBar.ItemTintColor()
        NavigationBar.Title()
        //TabBar.Color()
        //TabBar.TintColor()
        //TabBar.ItemsTitleColor()
        //SearchBar.Color()
    }
}

public class SearchBar: NSObject{
    
    class func Color(bar: UISearchBar){
        bar.searchBarStyle = UISearchBarStyle.Prominent
        bar.barTintColor = StaticColorBank.HoxroBrandColor
        bar.tintColor = UIColor.whiteColor()
    }
    
    class func ChangeTextAppearance(bar: UISearchBar, text: String = ""){
        bar.placeholder = text
        UILabel.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = StaticColorBank.HoxroBrandColor
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).textColor = StaticColorBank.HoxroBrandColor
    }
    
    private class func getAttributes(text: String, color: UIColor) -> NSAttributedString{
        let attribute = NSMutableAttributedString(string: text)
        let range = (text as NSString).rangeOfString(text, options: NSStringCompareOptions.CaseInsensitiveSearch)
        attribute.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        return attribute
    }
}

public class NavigationBar: NSObject{
    
    class func Color(){
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = StaticColorBank.navBarTintColor
    }
    
    class func ItemTintColor(){
        UINavigationBar.appearance().tintColor = StaticColorBank.navBarItemTintColor
    }
    
    class func Title(){
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:StaticColorBank.titleColor
            , NSFontAttributeName: FontConfig.defaultFont(style: FontStyle.Medium, size: 15.0)]
    }
    
}

public class TabBar: NSObject{
    
    class func Color(){
        UITabBar.appearance().translucent = false
        UITabBar.appearance().barTintColor = StaticColorBank.tabBarTintColor
        UITabBar.appearance().backgroundImage = UIImage(catalog: AssetCatalog.tabBarBackground)
    }
    
    class func TintColor(){
        UITabBar.appearance().tintColor = StaticColorBank.tabBarItemTintColor
        let tabIndicator = UIImage(catalog: AssetCatalog.tabBarSelectionIndicator)?.imageWithRenderingMode(.AlwaysTemplate)
        let tabResizableIndicator = tabIndicator?.resizableImageWithCapInsets(UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
    }
    
    class func ItemsTitleColor(){
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -4.0)
        UITabBarItem.appearance().setTitleTextAttributes([ NSFontAttributeName: FontConfig.defaultFont(style: FontStyle.Bold, size: 11.0), NSForegroundColorAttributeName: StaticColorBank.tabItemTitleColor], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([ NSFontAttributeName: FontConfig.defaultFont(style: FontStyle.Bold, size: 11.0),NSForegroundColorAttributeName: StaticColorBank.tabItemTitleSelectColor], forState: UIControlState.Selected)
    }
}

public class Slider: NSObject{
    
    class func Appearance(activateOn classTypes: [AnyObject.Type]? = nil){
        let minImg = UIImage(catalog: AssetCatalog.sliderMin).resizableImageWithCapInsets(UIEdgeInsetsMake(0, 5, 0, 0))
        let maxImg = UIImage(catalog: AssetCatalog.sliderMax).resizableImageWithCapInsets(UIEdgeInsetsMake(0, 5, 0, 0))
        let thumb = UIImage(catalog: AssetCatalog.sliderThumbNail)
        if classTypes == nil{
            UISlider.appearance().setMaximumTrackImage(maxImg, forState: UIControlState.Normal)
            UISlider.appearance().setMinimumTrackImage(minImg, forState: UIControlState.Normal)
            UISlider.appearance().setThumbImage(thumb, forState: UIControlState.Normal)
            UISlider.appearance().setThumbImage(thumb, forState: UIControlState.Highlighted)
        }
        else{
            UISlider.appearanceWhenContainedInInstancesOfClasses(classTypes!).setMaximumTrackImage(maxImg, forState: UIControlState.Normal)
            UISlider.appearanceWhenContainedInInstancesOfClasses(classTypes!).setMinimumTrackImage(minImg, forState: UIControlState.Normal)
            UISlider.appearanceWhenContainedInInstancesOfClasses(classTypes!).setThumbImage(thumb, forState: UIControlState.Normal)
            UISlider.appearanceWhenContainedInInstancesOfClasses(classTypes!).setThumbImage(thumb, forState: UIControlState.Highlighted)
        }
    }
    
}

public class SegmentControl: NSObject{
    
    class func Appearance(activateOn classTypes: [AnyObject.Type]? = nil){
        if classTypes == nil{
            UISegmentedControl.appearance().tintColor = StaticColorBank.buttonColor
        }
        else{
            UISegmentedControl.appearanceWhenContainedInInstancesOfClasses(classTypes!).tintColor = StaticColorBank.buttonColor
        }
    }
    
}

public class Button: NSObject{
    
    class func Appearance(sender: UIButton){
        View.Carv(sender)
        sender.backgroundColor = StaticColorBank.buttonColor
        sender.tintColor = StaticColorBank.buttonColor
        sender.setTitleColor(StaticColorBank.buttonTitleColor, forState: UIControlState.Normal)
        sender.setTitleColor(StaticColorBank.buttonTitleColor, forState: UIControlState.Selected)
    }
    
    class func DeleteAppearance(sender: UIButton){
        View.Carv(sender)
        sender.backgroundColor = UIColor.redColor()
        sender.tintColor = StaticColorBank.buttonColor
        sender.setTitleColor(StaticColorBank.buttonTitleColor, forState: UIControlState.Normal)
        sender.setTitleColor(StaticColorBank.buttonTitleColor, forState: UIControlState.Selected)
    }
    
    class func TitleAppearance(sender: UIButton){
        //TODO:
    }
    
}

public class View: NSObject{
    
    class func Carv(sender: UIView, by value: CGFloat = 2.5){
        let layer = sender.layer
        layer.masksToBounds = true
        layer.cornerRadius = value
    }
    
    class func Border(sender: UIView, color: UIColor, width: CGFloat = 1.5){
        let layer = sender.layer
        layer.borderColor = color.CGColor
        layer.borderWidth = width
    }
    
    @available(iOS 8.0, *)
    class func createVisualEffect(frame: CGRect, style: UIBlurEffectStyle = UIBlurEffectStyle.Dark) -> UIVisualEffectView{
        let blurEfect = UIBlurEffect(style: style)
        let visualEffectView = UIVisualEffectView(effect: blurEfect)
        visualEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        visualEffectView.frame = frame
        return visualEffectView
    }
}

public class Text: NSObject{
    
    class func dynamicSize(text: NSString, font: UIFont, maxSize: CGSize? = nil) -> CGSize{
        let availableSize: CGSize = (maxSize != nil) ? maxSize! : CGSize(width: CGFloat(320.0), height: CGFloat(MAXFLOAT))
        let size: CGSize = text.boundingRectWithSize(availableSize
            , options: NSStringDrawingOptions.UsesLineFragmentOrigin
            , attributes: [NSFontAttributeName: font]
            , context: nil).size
        return size
    }
    
}

