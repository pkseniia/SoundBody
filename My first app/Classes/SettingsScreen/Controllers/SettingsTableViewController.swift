//
//  SettingsTableViewController.swift
//  My first app
//
//  Created by ios02 on 05.03.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var editProfileCell: UITableViewCell!
    @IBOutlet weak var pushCell: UITableViewCell!
    @IBOutlet weak var isEnableSwitch: UISwitch!

    private struct Constants {
        static let editProfile = "Edit profile"
        static let pushNotifications = "Push notifications"
        static let settings = "SETTINGS"
        static let firstStartScreenID = "FirstStartScreenTableViewControllerID"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // Perform segue to EditProfileTableViewController.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // swiftlint:disable force_cast
            let editProfiletController = storyboard?
                .instantiateViewController(withIdentifier: Constants.firstStartScreenID) as! FirstStartScreenTableViewController
            let appearanceType: AppearanceType = .editProfile
            editProfiletController.appearanceType = appearanceType
            navigationController?.pushViewController(editProfiletController,
                                                     animated: true)
        }
    }

    // MARK: SetupUI
    private func setupUI() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        navigationItem.title = Constants.settings

        editProfileCell.textLabel?.text = Constants.editProfile
        editProfileCell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        editProfileCell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        editProfileCell.selectionStyle = UITableViewCellSelectionStyle.none

        tableView.tableFooterView = UIView()

        pushCell.selectionStyle = UITableViewCellSelectionStyle.none
        pushCell.textLabel?.text = Constants.pushNotifications
        pushCell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
        if UserDefaults.standard.bool(forKey: AppConstants.LocalPushNotifications.push) == true {
            isEnableSwitch.isOn = true
        } else {
            isEnableSwitch.isOn = false
        }
    }

    // Method for on/off push notifications.
    @IBAction func pushSwitch(_ sender: UISwitch) {
        if isEnableSwitch.isOn == true {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                if settings.authorizationStatus == .denied {
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else { return }
                    DispatchQueue.main.async {
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)")
                            })
                        }
                    }
                    UserDefaults.standard.set(true, forKey: AppConstants.LocalPushNotifications.push)
                } else {
                    UserDefaults.standard.set(true, forKey: AppConstants.LocalPushNotifications.push)
                }
            }
        } else {
            UserDefaults.standard.set(false, forKey: AppConstants.LocalPushNotifications.push)
        }
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

}
