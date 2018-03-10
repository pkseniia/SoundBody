//
//  ResultOfSearchTableViewController.swift
//  My first app
//
//  Created by ios02 on 26.02.18.
//  Copyright © 2018 ios02. All rights reserved.
//

import UIKit

class ResultOfSearchTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    private struct Constants {
        static let ProductWeightID = "ProductWeightViewControllerID"
    }

    let searchController = UISearchController(searchResultsController: nil)
    private var resultOfSearch = [ProductID]()
    var query = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self

        setupUI()
    }

    // MARK: - TableView's UI.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultOfSearch.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let product = resultOfSearch[indexPath.row]
        cell.textLabel?.text = product.name
        return cell
    }

    // Transport data to ProductWeightViewController.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectedProduct = resultOfSearch[indexPath.row]

        // swiftlint:disable force_cast
        let productWeightController = storyboard
            .instantiateViewController(withIdentifier: Constants.ProductWeightID) as! ProductWeightViewController

        productWeightController.selectedProductID = selectedProduct.ID
        productWeightController.selectedProductName = selectedProduct.name
        navigationController?.pushViewController(productWeightController,
                                                 animated: true)
    }

    // Request when tapping text in search.
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
        searchQuery.count > 0
            else { return }
        query = searchQuery
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(makeRequest), object: nil)
        perform(#selector(makeRequest), with: query, afterDelay: 0.5)
        }

    /// Get request for productID.
    @objc private func makeRequest() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            ProductService.shared.getID(with: self.query, completionHandler: { products, error in
                if let error = error {
                    self.showDefaultAlert(title: "Error", message: "Something goes wrong with: \(error.localizedDescription)")
                } else if let products = products {
                    self.resultOfSearch = products
                    DispatchQueue.main.async {
                        self.tableView.reloadSections([0], with: .fade)
                    }
                }
            })
        }
    }

    // Search button on keyboard.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button tapped")
    }

    // MARK: SetupUI
    private func setupUI() {
        navigationController?.navigationBar.backgroundColor = UIColor(red: 189/255.0, green: 234/255.0, blue: 221/255.0, alpha: 1)
        searchController.dimsBackgroundDuringPresentation = true
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView()
    }
}
