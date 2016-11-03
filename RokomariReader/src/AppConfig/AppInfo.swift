//
//  AppInfo.swift
//  DubaiArchive
//
//  Created by Towhid on 4/27/15.
//  Copyright (c) 2016 Rokomari (https://www.rokomari.com/policy). All rights reserved.
//

import Foundation
import UIKit

class AppInfo: NSObject {
    
    struct ConstentKeys {
        static let MainStoryboardNameKey = "UIMainStoryboardFile"
        static let FileSharingEnabledKey = "UIFileSharingEnabled"
        static let BundleNameKey = "CFBundleName"
        static let BundleDisplayNameKey = "CFBundleDisplayName"
        static let AppDisplayNameKey = "CFBundleDisplayName"
        static let BundleIdentifierKey = "CFBundleIdentifier"
        static let VersionNameKey = "CFBundleShortVersionString"
        static let BuildVersionNameKey = "CFBundleVersion"
        static let WifiRequiredKey = "UIRequiresPersistentWiFi"
        static let DeviceFamilyKey = "UIDeviceFamily"
        static let IPhoneSupportedKey = "iPhone"
        static let IPodSupportedKey = "iPod"
        static let IPadSupportedKey = "iPad"
        static let AppIconNameKey = "CFBundleIconFile"
        static let AppIconNamesKey = "CFBundleIconFiles"
    }
    
    func stringValue(forKey key: String) -> String?{
        var result: String?
        if let value = NSBundle.mainBundle().infoDictionary![key] as? String{
            result = value
        }
        return result
    }
    
    func booleanValue(forKey key: String) -> Bool?{
        var result: Bool?
        if let value = NSBundle.mainBundle().infoDictionary![key] as? NSNumber{
            result = value.boolValue
        }
        return result
    }
    
    func numberValue(forKey key: String) -> NSNumber?{
        var result: NSNumber?
        if let value = NSBundle.mainBundle().infoDictionary![key] as? NSNumber{
            result = value
        }
        return result
    }
    
    func integerValue(forKey key: String) -> Int?{
        let result: NSNumber? = numberValue(forKey: key)
        return result?.integerValue
    }
    
    func doubleValue(forKey key: String) -> Double?{
        let result: NSNumber? = numberValue(forKey: key)
        return result?.doubleValue
    }
    
    func deviceSupported(forKey key: String) -> Bool{
        //
        var result: Bool = false
        if let list = NSBundle.mainBundle().infoDictionary![ConstentKeys.DeviceFamilyKey] as? Array<Int>{
            for value in list{
                result = deviceSupportCheck(value, key: key)
                if result{
                    break
                }
            }
        }
        else if let value = NSBundle.mainBundle().infoDictionary![ConstentKeys.DeviceFamilyKey] as? Int{
            result = deviceSupportCheck(value, key: key)
        }
        return result
    }
    
    private func deviceSupportCheck(value: Int, key: String) -> Bool{
        //
        var result = false
        switch(key){
        case ConstentKeys.IPhoneSupportedKey, ConstentKeys.IPodSupportedKey:
            result = (value == 1)
        case ConstentKeys.IPadSupportedKey:
            result = (value == 2)
        default:
            result = false
        }
        
        return result
    }
    
    func mainStoryboard(storyboardName: String? = nil) -> UIStoryboard?{
        if let name = storyboardName{
            let storyboard = UIStoryboard(name: name, bundle: nil)
            return storyboard
        }else{
            let storyboard = UIStoryboard(name: self.mainStoryboardName!, bundle: nil)
            return storyboard
        }
    }
    
    func appIcon() -> UIImage?{
        //
        if let iconNames = NSBundle.mainBundle().infoDictionary![ConstentKeys.AppIconNamesKey] as? [String]{
            if let iconName = iconNames.first{
                let icon = UIImage(named: iconName)
                return icon
            }
        }
        return nil
    }
    
    func languageID() -> String{
        return NSLocale.preferredLanguages().first as String!
    }
    
    func languageDisplayName() -> String?{
        let langID = languageID()
        return NSLocale.systemLocale().displayNameForKey(NSLocaleLanguageCode, value: langID)
    }
    
    func appVersionUpdated() -> Bool{
        return appUpdated(ConstentKeys.VersionNameKey, savedKey: "VersionTrackerKey")
    }
    
    func appBuildUpdated() -> Bool{
        return appUpdated(ConstentKeys.BuildVersionNameKey, savedKey: "BuildTrackerKey")
    }
    
    private func appUpdated(constantKey: String, savedKey: String) -> Bool{
        let userDefault = NSUserDefaults.standardUserDefaults()
        guard let currentVersion = stringValue(forKey: constantKey) else{
            return false
        }
        if let version =  userDefault.stringForKey(savedKey){
            let updated = version.containsString(currentVersion) //true means didn't updated.
            userDefault.setObject(currentVersion, forKey: savedKey)
            userDefault.synchronize()
            return !updated
        }else{
            userDefault.setObject(currentVersion, forKey: savedKey)
            userDefault.synchronize()
            return true
        }
    }
    
    //MARK: Just Lagecy
    
    lazy private var mainStoryboardName: String? = {
        var storyboardName: String? = NSBundle.mainBundle().infoDictionary![ConstentKeys.MainStoryboardNameKey] as? String
        return storyboardName
    }()
    
    lazy private var iTuneFileShareEnabled: Bool = {
        var result = false
        if let fileShareEnabled = NSBundle.mainBundle().infoDictionary![ConstentKeys.FileSharingEnabledKey] as? NSNumber{
            return fileShareEnabled.boolValue
        }
        return result
    }()
    
    lazy private var bundleName: String? = {
        var result: String?
        if let bundleStr = NSBundle.mainBundle().infoDictionary![ConstentKeys.BundleNameKey] as? String{
            result = bundleStr
        }
        return result
    }()
    
}