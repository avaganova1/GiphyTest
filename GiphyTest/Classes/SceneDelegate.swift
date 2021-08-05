//
//  SceneDelegate.swift
//  GiphyTest
//
//  Created by Ваганова Анастасия on 05.08.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: CategoriesViewController())
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) { }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) { }

    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) { }

    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) { }

    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) { }
}
