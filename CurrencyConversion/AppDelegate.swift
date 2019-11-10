//
//  AppDelegate.swift
//  CurrencyConversion
//
//  Created by Yi-Ling Wu on 2019/11/08.
//  Copyright © 2019 Yi-Ling Wu. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        APIManager.shared.loadLocalCurrencyRate()
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "co.yiling.CurrencyConversion.currencyRateUpdate", using: nil) { task in
            if let bgTask = task as? BGAppRefreshTask {
                self.backgroundFetch(bgTask)
            }
        }
        return true
    }

    func backgroundFetch(_ task: BGAppRefreshTask) {
        task.expirationHandler = {
            APIManager.shared.requestCurrenctRate()
            print("Did Excute Background Fetch")
        }
        task.setTaskCompleted(success: true)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }

    func scheduleAppRefresh() {
        let lastRefreshedTime = CurreuncyRateUserDefault.lastRefreshed()
        let now = Date()
        let minDuration = TimeInterval(12 * 60 * 60) // query per half day

        guard now > (lastRefreshedTime + minDuration) else { return }

        let request = BGProcessingTaskRequest(identifier: "co.yiling.CurrencyConversion.currencyRateUpdate")
        request.requiresNetworkConnectivity = true
        request.requiresExternalPower = false

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule schedule refresh: \(error)")
        }
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
