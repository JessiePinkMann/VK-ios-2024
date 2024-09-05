//
//  SceneDelegate.swift
//  VK_mimiApps
//
//  Created by Egor Anoshin on 05.09.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Создаем окно и назначаем корневой ViewController
        window = UIWindow(windowScene: windowScene)
        let mainViewController = MainViewController()
        
        // Упаковываем в UINavigationController
        let navigationController = UINavigationController(rootViewController: mainViewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}


