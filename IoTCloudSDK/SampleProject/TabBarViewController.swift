//
//  TabBarViewController.swift
//  SampleProject
//
//  Created by Yongping on 8/24/15.
//  Copyright © 2015 Kii Corporation. All rights reserved.
//

import UIKit
import IoTCloudSDK

class TabBarViewController: UITabBarController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        var savedIoTAPI: IoTCloudAPI?

        // try to get iotAPI from NSUserDefaults
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("iotAPI") as? NSData {
            savedIoTAPI = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? IoTCloudAPI
        }

        // if there is not saved iotAPI, present login UIs
        if savedIoTAPI == nil {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginRootNaviVC = storyBoard.instantiateViewControllerWithIdentifier("LoginRootViewController") as! UINavigationController
            self.presentViewController(loginRootNaviVC, animated: true, completion: nil)
        }
    }
}
