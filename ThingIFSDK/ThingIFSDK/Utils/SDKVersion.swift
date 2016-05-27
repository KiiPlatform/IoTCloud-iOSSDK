//
//  SDKVersion.swift
//  ThingIFSDK
//
//  Copyright © 2016年 Kii. All rights reserved.
//
import UIKit

/** Accessor of the Thing-IF SDK version. */
public class SDKVersion: NSObject {
    public static let sharedInstance = SDKVersion()
    /** Version of the Thing-IF SDK */
    private var _header : String?
    private var _versionString : String?

    public var versionString:String { if _versionString == nil {
        let b:NSBundle? = NSBundle.allFrameworks().filter{$0.bundleIdentifier == "Kii-Corporation.ThingIFSDK"}.first
        _versionString = b?.infoDictionary?["CFBundleShortVersionString"] as! String?
        }
        return _versionString!
    }
    internal var kiiSDKHeader:String {
        if _header == nil {
            _header = "sn=it;sv=\(versionString);pv=\(UIDevice.currentDevice().systemVersion)"
        }

        return _header!
    }
    private override init() {
    }
}
