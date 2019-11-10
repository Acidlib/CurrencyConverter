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
                self.handleAppRefresh(task: bgTask)
            }
        }
        scheduleAppRefresh()
        return true
    }

    func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        task.expirationHandler = {
            APIManager.shared.requestCurrenctRate()
            print("Did Excute Background Fetch")
            CurreuncyRateUserDefault.setLastRefresh(time: Date())
        }
        task.setTaskCompleted(success: true)
    }

    func scheduleAppRefresh() {
        let lastRefreshedTime = CurreuncyRateUserDefault.lastRefreshed()
        let now = Date()
        let minDuration = TimeInterval(12 * 60 * 60) // query per half day
        guard now > (lastRefreshedTime + minDuration) else { return }

        let request = BGAppRefreshTaskRequest(identifier: "co.yiling.CurrencyConversion.currencyRateUpdate")

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule schedule refresh: \(error)")
        }
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}
