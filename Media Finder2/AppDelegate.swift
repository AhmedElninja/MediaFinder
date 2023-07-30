//
//  AppDelegate.swift
//  Media Finder2
//
//  Created by Ahmed Alaa on 24/04/2023.
//

import IQKeyboardManagerSwift
import SQLite

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Proprepties.
    var window: UIWindow?
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: Storyboards.main, bundle: nil)

    // MARK: - Application Methods.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DataBaseManger.shared.setUpConnection()
        handleRoot()
        IQKeyboardManager.shared.enable = true
        return true
    }
    // MARK: - Public Methods.
    public func goToSignInVC() {
        let signInVC: SignInVC = mainStoryboard.instantiateViewController(withIdentifier: Views.signInVC) as! SignInVC
        let navigationController = UINavigationController.init(rootViewController: signInVC)
        self.window?.rootViewController = navigationController
    }
    public func goToMediaVC() {
        let mediaVC: MediaVC = mainStoryboard.instantiateViewController(withIdentifier: Views.mediaVC) as! MediaVC
        let navigationController = UINavigationController.init(rootViewController: mediaVC)
        self.window?.rootViewController = navigationController
    }
}
// MARK: - Private Methods.
extension AppDelegate {
    private func handleRoot() {
        if let userLoggedIn = UserDefaults.standard.object(forKey: UserDefultKeys.isUserloggedIn) as? Bool {
            if userLoggedIn {
                goToMediaVC()
            } else {
                goToSignInVC()
            }
        }
    }

}

