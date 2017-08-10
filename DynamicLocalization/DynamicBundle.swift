//
//  DynamicBundle.swift
//  DynamicLocalization
//
//  Created by Vincent on 10/08/2017.
//  Copyright © 2017 Vincent. All rights reserved.
//

import Foundation

private var kBundleKey = 0

class DynamicBundle: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &kBundleKey) as? Bundle {
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
        
        if let localizationBundlePath = Bundle.main.path(forResource: language, ofType: "lproj"),
            let localizationBundle = Bundle(path: localizationBundlePath) {
            objc_setAssociatedObject(Bundle.main, &kBundleKey, localizationBundle, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            NotificationCenter.default.post(name: LocalizationWasModifiedNotification, object: nil)
        }
    }
}
