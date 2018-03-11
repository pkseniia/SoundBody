//
//  InfographicViewController.swift
//  My first app
//
//  Created by ios02 on 12.02.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import UIKit
import UserNotifications

class InfographicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var infographicTableView: UITableView!
    @IBOutlet weak var itemOutlet: UITabBarItem!

    let titles = ["Calories", "Protein", "Fat", "Carbohydrates"]
    var userNutritionDay = [Double]()
    var contentString = "You have already exceed your daily "

    private struct Constants {
        static let InfographicCellIdentifier = "InfographicTableViewCell"
        static let cellHeight: CGFloat = 160
        static let dailyRate = "YOUR DAILY RATE"
        static let userNutritionDay = "UserNutritionDay"
        static let emptyArray = [0.0, 0.0, 0.0, 0.0]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        infographicTableView.delegate = self
        infographicTableView.dataSource = self

        // MARK: Custom cell registration
        infographicTableView.register(UINib(nibName: Constants.InfographicCellIdentifier,
                                            bundle: nil),
                                      forCellReuseIdentifier: Constants.InfographicCellIdentifier)
        pushNotificationRequest()
        userNutritionDay = UserDefaults.standard.array(forKey: Constants.userNutritionDay) as? [Double] ?? Constants.emptyArray
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        infographicTableView.reloadData()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    /// Method received data from Notification Center.
    private func subscribeForNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDayData(notification:)),
                                               name: AppConstants.Notifications.notificationName,
                                               object: nil)
    }

    @objc private func updateDayData(notification: NSNotification) {
        guard let userDay = notification.object as? [Double] else { return }
        userNutritionDay = userDay
        UserDefaults.standard.set(userNutritionDay, forKey: Constants.userNutritionDay)
    }

    // Unsubscribe from Notification Center.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    /// Method for permission in local push notification.
    private func pushNotificationRequest() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isAllow, error)  in
            let defaults = UserDefaults.standard
            if isAllow == true {
                defaults.set(true, forKey: AppConstants.LocalPushNotifications.push)
            } else {
                defaults.set(false, forKey: AppConstants.LocalPushNotifications.push)
            }
            guard let error = error else { return }
            print(error.localizedDescription)
        }
    }

    // MARK: SetupUI
    private func setupUI() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        navigationItem.title = Constants.dailyRate
        tabBarController?.tabBar.barTintColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        infographicTableView.allowsSelection = false
        infographicTableView.tableFooterView = UIView()
    }

    // MARK: TableView's UI.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        subscribeForNotification()

        // swiftlint:disable force_cast
        let nutritionCell = tableView.dequeueReusableCell(withIdentifier: Constants.InfographicCellIdentifier, for: indexPath)
            as! InfographicTableViewCell

        let userNutritionGoal = [Double(UserDefaults.standard.integer(forKey: AppConstants.UserDefaultKey.kcalDefaultKey)),
                             UserDefaults.standard.double(forKey: AppConstants.UserDefaultKey.proteinDefaultKey),
                             UserDefaults.standard.double(forKey: AppConstants.UserDefaultKey.fatDefaultKey),
                             UserDefaults.standard.double(forKey: AppConstants.UserDefaultKey.carbsDefaultKey)]

        nutritionCell.configure(goalArrayElement: userNutritionGoal[indexPath.row],
                                dayArrayElement: userNutritionDay[indexPath.row],
                                titlesElement: titles[indexPath.row])

            if UserDefaults.standard.bool(forKey: AppConstants.LocalPushNotifications.push) == true {
                if userNutritionGoal[indexPath.row] <= userNutritionDay[indexPath.row] {
                    let content = UNMutableNotificationContent()
                    content.title = "Oh, no!"
                    contentString.append("\(titles[indexPath.row].lowercased()), ")
                    content.subtitle = contentString
                    content.badge = 1

                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                    let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
        return nutritionCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
