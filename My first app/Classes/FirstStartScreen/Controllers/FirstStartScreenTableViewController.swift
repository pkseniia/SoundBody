//
//  FirstStartScreenTableViewController.swift
//  My first app
//
//  Created by ios02 on 08.02.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import UIKit

enum AppearanceType {
    case login
    case editProfile
}

class FirstStartScreenTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var rowLabelFirst: UITableViewCell!
    @IBOutlet weak var rowLabelSecond: UITableViewCell!
    @IBOutlet weak var rowLabelThird: UITableViewCell!
    @IBOutlet weak var rowLabelFourth: UITableViewCell!
    @IBOutlet weak var rowLabelFifth: UITableViewCell!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!

    // Constants.
    struct Constants {
        static let MainScreen = "MainScreen"
        static let selectYourGender = "Select your gender"
        static let selectWeightGoal = "Select weight goal"
        static let selectYourWeight = "Select your weight"
        static let yourGender = UserDefaults.standard.string(forKey: AppConstants.UserDefaultKey.genderDefaultKey)
        static let yourWeight = "\(UserDefaults.standard.integer(forKey: AppConstants.UserDefaultKey.weightDefaultKey)) kg"
        static let yourGoal = UserDefaults.standard.string(forKey: AppConstants.UserDefaultKey.goalDefaultKey)
    }
    // Default appearance for login screen.
    var appearanceType: AppearanceType! = .login

    // Announce vars for picker.
    private var pickerGender = UIPickerView()
    private var pickerGoal = UIPickerView()
    private var pickerWeight = UIPickerView()

    // Arrays for choice.
    private var allGender = [Person.GenderType.man.rawValue,
                     Person.GenderType.woman.rawValue]
    private var allWeight = Array(40...150)
    private var allGoal = [Person.GoalType.lose.rawValue,
                   Person.GoalType.maintain.rawValue,
                   Person.GoalType.gain.rawValue]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // Action button.
    @IBAction func buttonAction(_ sender: UIButton) {
        guard let genderString = genderTextField.text,
            let goalString = goalTextField.text,
            let weightString = weightTextField.text,
        let weightNumberString = weightString.components(separatedBy: " ").first,
        let weight = Int(weightNumberString)
            else {
                showDefaultAlert(title: "Error", message: "The data has to be chosen")
                return
        }
        if genderString.count > 0 && weightString.count > 0 && goalString.count > 0 {

            let defaults = UserDefaults.standard

            defaults.set(weight, forKey: AppConstants.UserDefaultKey.weightDefaultKey)
            defaults.set(genderString, forKey: AppConstants.UserDefaultKey.genderDefaultKey)
            defaults.set(goalString, forKey: AppConstants.UserDefaultKey.goalDefaultKey)

            let user = Person()
            user.calculateKPFC()

            guard let appearanceType = appearanceType else { return }
            switch appearanceType {
            case .login:
                defaults.set(true, forKey: AppConstants.ScreenToShow.userSignedIn)
                performSegue(withIdentifier: Constants.MainScreen, sender: nil)

            case .editProfile:
                navigationController?.popViewController(animated: true)
            }
        }
    }

    // MARK: SetupUI
    private func setupUI() {
        // MARK: PickerView's UI
        allGender.insert("", at: 0)
        allGoal.insert("", at: 0)
        pickerGender.delegate = self
        genderTextField.inputView = pickerGender
        genderTextField.textAlignment = .center

        pickerGoal.delegate = self
        goalTextField.inputView = pickerGoal
        goalTextField.textAlignment = .center

        pickerWeight.delegate = self
        weightTextField.inputView = pickerWeight
        weightTextField.textAlignment = .center

        // Put bar with Done button in every picker.
        let bar = toolBar()
        genderTextField.inputAccessoryView = bar
        goalTextField.inputAccessoryView = bar
        weightTextField.inputAccessoryView = bar

        // TableView's UI.
        logoImage.image = UIImage.init(named: "logo")

        view.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        rowLabelFirst.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        rowLabelSecond.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        rowLabelThird.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        rowLabelFourth.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        rowLabelFifth.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)

        tableView.allowsSelection = false

        guard let appearanceType = appearanceType else { return }
            switch appearanceType {
            case .login: buttonStyle(title: "Start", button: buttonLabel)
                genderTextField.placeholder = Constants.selectYourGender
                goalTextField.placeholder = Constants.selectWeightGoal
                weightTextField.placeholder = Constants.selectYourWeight

            case .editProfile: buttonStyle(title: "Save", button: buttonLabel)
                navigationItem.title = "EDIT PROFILE"
                genderTextField.placeholder = Constants.yourGender
                goalTextField.placeholder = Constants.yourGoal
                weightTextField.placeholder = Constants.yourWeight
        }
    }

    /// Func for making bar with "Done" button in PickerView
    private func toolBar() -> UIToolbar {
        let bar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: nil, action: #selector(closeKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [space, doneButton]
        return bar
    }

    @objc private func closeKeyboard() {
        view.endEditing(true)
    }

    // MARK: - UIPickerView's required funcs
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerGender {
            return allGender[row]
        } else if pickerView == pickerGoal {
            return allGoal[row]
        }
        return ("\(allWeight[row]) kg")
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerGender {
            let chosen = allGender[row]
            genderTextField.text = chosen
        } else if pickerView == pickerGoal {
            let chosen = allGoal[row]
            goalTextField.text = chosen
        } else if pickerView === pickerWeight {
            let chosen = allWeight[row]
            weightTextField.text = "\(chosen) kg"
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === pickerGender {
            return allGender.count
        } else if pickerView === pickerGoal {
            return allGoal.count
        }
        return allWeight.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
