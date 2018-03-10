//
//  DiaryViewController.swift
//  My first app
//
//  Created by ios02 on 18.02.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import UIKit
import RealmSwift

class DiaryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var diaryTableView: UITableView!
    @IBOutlet weak var trashButtonOutlet: UIBarButtonItem!

    private struct Constants {
        static let DiaryCellIdentifier = "DiaryTableViewCell"
        static let addNewProductSegue = "addNewProductSegue"
        static let cellHeight: CGFloat = 145
        static let dailyDiet = "YOUR DAILY DIET"
    }

    private var productAdded = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()

        diaryTableView.delegate = self
        diaryTableView.dataSource = self

        // Custom cell registration.
        diaryTableView.register(UINib(nibName: Constants.DiaryCellIdentifier, bundle: nil),
                                forCellReuseIdentifier: Constants.DiaryCellIdentifier)
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        updateAddedproducts()
        isTrashEnable()
        diaryTableView.reloadSections([0], with: .fade)
    }

    // Add button goes to ResultOfSearchTableViewController.
    @IBAction func addNewProductButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.addNewProductSegue, sender: nil)
    }

    // MARK: SetupUI
    private func setupUI() {

        navigationController?.navigationBar.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        navigationItem.title = Constants.dailyDiet
        navigationController?.navigationBar.shadowImage = nil
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        diaryTableView.allowsSelection = false
        diaryTableView.tableFooterView = UIView()
    }

    // MARK: TableView UI
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productAdded.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let searchResultCell = tableView.dequeueReusableCell(withIdentifier: Constants.DiaryCellIdentifier,
                                                             for: indexPath) as! DiaryTableViewCell

        let currentProduct = productAdded[indexPath.row]
        searchResultCell.configure(with: currentProduct)
        return searchResultCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

    /// Making array with data of nutrients per day for chart.
    private func dataFomChart() {
        var energyArray = [Double]()
        var proteinArray = [Double]()
        var fatArray = [Double]()
        var carbsArray = [Double]()
        for element in productAdded {
            energyArray.append(element.energy)
            proteinArray.append(element.protein)
            fatArray.append(element.fat)
            carbsArray.append(element.carb)
        }

        var sumEnergy = energyArray.reduce(0, +)
        sumEnergy = Double(round(10*sumEnergy)/10)
        var sumProtein = proteinArray.reduce(0, +)
        sumProtein = Double(round(10*sumProtein)/10)
        var sumFat = fatArray.reduce(0, +)
        sumFat = Double(round(10*sumFat)/10)
        var sumCarbs = carbsArray.reduce(0, +)
        sumCarbs = Double(round(10*sumCarbs)/10)

        let userNutritionDay = [sumEnergy, sumProtein, sumFat, sumCarbs]
        NotificationCenter.default.post(name: AppConstants.Notifications.notificationName, object: userNutritionDay)
    }

    /// Method updates array with products added from Realm.
    private func updateAddedproducts() {
        do {
            let realm = try Realm()
            let objects = realm.objects(Product.self)
            let objectsArray = Array(objects)
            productAdded = objectsArray
        } catch {
            print(error.localizedDescription)
        }
        dataFomChart()
    }

    // Delete a row.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            let product = productAdded[indexPath.row]

            do {
                let realm = try Realm()
                do {
                    try realm.write {
                        realm.delete(product)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            } catch {
                print(error.localizedDescription)
            }

            updateAddedproducts()
            diaryTableView.deleteRows(at: [indexPath], with: .automatic)
            isTrashEnable()
            diaryTableView.reloadData()
        }
    }

    /// Checks if the trash button is needed.
    private func isTrashEnable() {
        if productAdded.count == 0 {
            trashButtonOutlet.isEnabled = false
        } else {
            trashButtonOutlet.isEnabled = true
        }
    }

    // Delete all data's button.
    @IBAction func deleteAllButton(_ sender: UIBarButtonItem) {

        do {
            let realm = try Realm()
            do {
                try realm.write {
                   realm.deleteAll()
                }
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
        updateAddedproducts()
        isTrashEnable()
        diaryTableView.reloadData()
    }
}
