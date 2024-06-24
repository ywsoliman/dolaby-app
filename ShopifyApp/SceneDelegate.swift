//
//  SceneDelegate.swift
//  ShopifyApp
//
//  Created by Youssef Waleed on 23/05/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        let authStoryboard = UIStoryboard(name: "Samuel", bundle: nil)
        let homeStoryboard = UIStoryboard(name: "Israa", bundle: nil)

        let homeViewController =
        homeStoryboard.instantiateViewController(identifier: "HomeViewController") as! UINavigationController
        
        guard let onboardingViewController = authStoryboard.instantiateViewController(withIdentifier: "onboardingVC") as? OnboardingViewController else {
            fatalError("Unable to instantiate desired view controller.")
        }
        
        let loginViewController = authStoryboard.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
            
        let onboardingShown = UserDefaults.standard.bool(forKey: "onboardingShown")
        
        if let windowScene = scene as? UIWindowScene {

            let window = UIWindow(windowScene: windowScene)
            
            if isUserAlreadyLoggedIn() {
                window.rootViewController = homeViewController
            } else if onboardingShown {
                window.rootViewController = loginViewController
            } else {
                window.rootViewController = onboardingViewController
            }
            
            self.window = window
            window.makeKeyAndVisible()
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func isUserAlreadyLoggedIn() -> Bool {
        do {
            let data = try LocalDataSource.shared.retrieveCustomerId()
            print("Found data logged in before")
            print("Found data logged in before\(data)")
            return true
        } catch{
            print("there is no data")
            return false
        }
    }
}

