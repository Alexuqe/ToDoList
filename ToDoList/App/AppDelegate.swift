//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Sasha on 20.02.25.
//

import UIKit
import CoreData

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let storageManager = StorageManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let viewController = TaskListRouter.createdModule()
        window?.rootViewController = UINavigationController(rootViewController: viewController)
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        storageManager.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        storageManager.saveContext()
    }

}
