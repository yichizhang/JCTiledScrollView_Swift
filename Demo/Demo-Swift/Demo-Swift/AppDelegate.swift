//
//  Copyright (c) 2015-present Yichi Zhang
//  https://github.com/yichizhang
//  zhang-yi-chi@hotmail.com
//
//  This source code is licensed under MIT license found in the LICENSE file
//  in the root directory of this source tree.
//  Attribution can be found in the ATTRIBUTION file in the root directory 
//  of this source tree.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool
    {
        // Override point for customization after application launch.
        let tc = UITabBarController()

        let vc1 = ViewController()
        vc1.mode = JCDemoType.PDF
        vc1.tabBarItem = UITabBarItem(title: "PDF", image: DemoStyleKit.image(string: "pdf"), selectedImage: nil)

        let vc2 = ViewController()
        vc2.mode = JCDemoType.Image
        vc2.tabBarItem = UITabBarItem(title: "Image", image: DemoStyleKit.image(string: "img"), selectedImage: nil)

        tc.viewControllers = [vc1, vc2]
        tc.tabBar.isTranslucent = false
        window?.rootViewController = tc

        return true
    }
}

