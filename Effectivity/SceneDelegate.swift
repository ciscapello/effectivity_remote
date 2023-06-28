//
//  SceneDelegate.swift
//  Effectivity
//
//  Created by Владимир on 23.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        let navVC = UINavigationController()
        let viewController  = MainViewController()
        navVC.viewControllers = [viewController]
        window?.windowScene = windowScene
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}

