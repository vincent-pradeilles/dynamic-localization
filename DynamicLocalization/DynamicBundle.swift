//
//  DynamicBundle.swift
//  DynamicLocalization
//
//  Created by Vincent on 10/08/2017.
//  Copyright © 2017 Vincent. All rights reserved.
//

import Foundation

class DynamicBundle: Bundle {
    
    static private var kCurrentLocalizationBundleKey = 0
    
    fileprivate var currentLocalizationBundle: Bundle? {
        get {
            return objc_getAssociatedObject(self, &DynamicBundle.kCurrentLocalizationBundleKey) as? Bundle
        }
        
        set {
            objc_setAssociatedObject(self, &DynamicBundle.kCurrentLocalizationBundleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle =  self.currentLocalizationBundle {
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
    }
}

let LocalizationWasModifiedNotification = Notification.Name("LocalizationWasModifiedNotification")

extension Bundle {
    
    class func setLanguage(_ language: String) {
        object_setClass(Bundle.main, DynamicBundle.self)
        
        if let newLocalizationBundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
            let newLocalizationBundle = Bundle(path: newLocalizationBundlePath) {
            (Bundle.main as? DynamicBundle)?.currentLocalizationBundle = newLocalizationBundle
            NotificationCenter.default.post(name: LocalizationWasModifiedNotification, object: nil)
        }
    }
}
