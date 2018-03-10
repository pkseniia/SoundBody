//
//  ProductWeightViewController.swift
//  My first app
//
//  Created by ios02 on 18.02.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import UIKit
import RealmSwift

class ProductWeightViewController: UIViewController {

    @IBOutlet weak var weightProductTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var productTitleLable: UILabel!

    private var nutrients = [ProductNutrients]()
    var selectedProductName = String()
    var selectedProductID = String()
    var energyValue = Double()
    var proteinValue = Double()
    var fatValue = Double()
    var carbsValue = Double()
    var query = Double()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    // MARK: Add button
    @IBAction func addButtonAction(_ sender: UIButton) {
        guard let weightProduct = weightProductTextField.text,
                weightProduct.count > 0,
                let weightProductDouble = Double(weightProduct)
            else {
                showDefaultAlert(title: "Error", message: "Add the weight of product")
                return }
        query = weightProductDouble / 100
        makeRequest()
        navigationController?.popToRootViewController(animated: true)
    }

    /// Get request
    private func makeRequest() {
        ProductService.shared.getNutrients(with: selectedProductID, completionHandler: { nutrient, error in
            if let error = error {
                self.showDefaultAlert(title: "Error", message: "Something goes wrong with: \(error.localizedDescription)")
            } else if let nutrient = nutrient {
                self.nutrients = nutrient
                self.saveData()
            }
        })
    }

    /// Add product to realm DB.
    private func saveProductToRealm() {

        let product = Product(name: self.selectedProductName,
                              weight: self.query,
                              energy: self.energyValue,
                              protein: self.proteinValue,
                              fat: self.fatValue,
                              carb: self.carbsValue)
        do {
            let realm = try Realm()
            do {
                try realm.write {
                    realm.add(product)
                }
            } catch {
                print(error.localizedDescription)
            }
        } catch {
            print(error.localizedDescription)
        }
        // Find realm file in your computer.
        // print(Realm.Configuration.defaultConfiguration.fileURL)
    }

    /// Method gets nutrients from parsed array and calculate them for tapped weight of food.
    private func saveData() {
        for element in self.nutrients {
            if element.name == "Energy" {
                let energyValueString = element.value
                self.energyValue = Double(energyValueString) ?? 0
                self.energyValue *= self.query
                self.energyValue = Double(round(10*energyValue)/10)
            }
            if element.name == "Protein" {
                let proteinValueString = element.value
                self.proteinValue = Double(proteinValueString) ?? 0
                self.proteinValue *= self.query
                self.proteinValue = Double(round(10*proteinValue)/10)
            }
            if element.name == "Total lipid (fat)" {
                let fatValueString = element.value
                self.fatValue = Double(fatValueString) ?? 0
                self.fatValue *= self.query
                self.fatValue = Double(round(10*fatValue)/10)
            }
            if element.name == "Carbohydrate, by difference" {
                let carbsValueString = element.value
                self.carbsValue = Double(carbsValueString) ?? 0
                self.carbsValue *= self.query
                self.carbsValue = Double(round(10*carbsValue)/10)
            }
        }
        saveProductToRealm()
    }

    // MARK: SetupUI
    private func setupUI() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        weightProductTextField.keyboardType = .numberPad
        view.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        productTitleLable.text = selectedProductName
        buttonStyle(title: "Add", button: addButton)
    }

}
