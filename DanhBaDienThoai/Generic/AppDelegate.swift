import UIKit
import Foundation
import IQKeyboardManagerSwift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
        let vc = HomeVC(nibName: "HomeVC", bundle: nil)
        let nv = UINavigationController(rootViewController: vc)
        window?.rootViewController = nv
        window?.makeKeyAndVisible()
        IQKeyboardManager.shared.toolbarTintColor = #colorLiteral(red: 0.9764705882, green: 0.2235294118, blue: 0.3882352941, alpha: 1)
        IQKeyboardManager.shared.enable = true
        return true
    }
}
