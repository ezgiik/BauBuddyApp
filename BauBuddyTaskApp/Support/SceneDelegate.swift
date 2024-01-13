//
//  SceneDelegate.swift
//  BauBuddyTaskApp
//
//  Created by EZGİ KARABAY on 8.01.2024.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: NSNotification.Name("UnauthorizedAccessDetected"), object: nil)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let authService = AuthService()
        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let accessToken = authService.getToken(), !accessToken.isEmpty {
            let auth = Auth(accessToken: accessToken)
            if let tabBarController = storyboard.instantiateViewController(identifier: "tabBar") as? UITabBarController {
                if let taskListView = tabBarController.viewControllers?.first as? TaskListView {
                    taskListView.auth = auth
                }
                window.rootViewController = tabBarController
            }
        } else {
            let loginVC = storyboard.instantiateViewController(identifier: "LoginView") as! LoginView
            window.rootViewController = loginVC
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }


    @objc func userDidLogout() {
        guard let _ = self.window?.windowScene else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: "LoginView") as! LoginView
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UnauthorizedAccessDetected"), object: nil)
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
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

