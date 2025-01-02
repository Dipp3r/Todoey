//
//  TodoeyApp.swift
//  Todoey
//
//  Created by Arun K on 30/12/24.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
}

@main
struct TodoeyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ToDoListContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
