//
//  DiaryTableViewCell.swift
//  My first app
//
//  Created by ios02 on 18.02.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameTextField: UILabel!
    @IBOutlet weak var productWeight: UILabel!
    @IBOutlet weak var caloriesName: UILabel!
    @IBOutlet weak var proteinName: UILabel!
    @IBOutlet weak var fatName: UILabel!
    @IBOutlet weak var carbsName: UILabel!
    @IBOutlet weak var caloriesText: UILabel!
    @IBOutlet weak var proteinText: UILabel!
    @IBOutlet weak var fatText: UILabel!
    @IBOutlet weak var carbsText: UILabel!
    @IBOutlet weak var divider: UIView!

    private struct Constants {
        static let energy = "Energy(kcal)"
        static let protein = "Protein(g)"
        static let fat = "Fat(g)"
        static let carbs = "Carbohydrate(g)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    /// Configure cell method.
    func configure(with product: Product) {
        productNameTextField.text = product.name
        productWeight.text = "\(Int(product.weight * 100)) g"
        caloriesText.text = "\(Int(product.energy))"
        proteinText.text = "\(product.protein)"
        fatText.text = "\(product.fat)"
        carbsText.text = "\(product.carb)"
    }

    // MARK: SetupUI
    private func setupUI() {
        divider.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        caloriesName.text = Constants.energy
        proteinName.text = Constants.protein
        fatName.text = Constants.fat
        carbsName.text = Constants.carbs
        productNameTextField.font = UIFont.boldSystemFont(ofSize: 20.0)
        productWeight.font = UIFont.boldSystemFont(ofSize: 20.0)
    }
}
