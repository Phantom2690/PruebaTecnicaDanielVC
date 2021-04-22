//
//  ViewController.swift
//  PruebaTecnicaBuscadorProductos
//
//  Created by Daniel Vazquez on 21/4/21.
//

import UIKit
import Alamofire

@objc enum order: Int {
    case predefined, lowerPrice, higherPrice
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var productSearch: UISearchBar!
    @IBOutlet weak var orderLabel: UILabel!
    
    let productTableCell = String(describing: ProductTableCell.self)
    var dataProducts: [Product] = []
    var searchText: String = "playera"
    var pageNumber = 1
    var totalNumRecs = 0
    var productsShowing = 0
    var myOrder: order = .predefined
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        productSearch.delegate = self
        searchProducts()
    }
    
    @IBAction func clickOrder(_ sender: Any) {
        switch myOrder {
        case .predefined:
            myOrder = .lowerPrice
            orderLabel.text = "Menor precio"
        case.lowerPrice:
            myOrder = .higherPrice
            orderLabel.text = "Mayor precio"
        default:
            myOrder = .predefined
            orderLabel.text = "Predefinido"
        }

        self.dataProducts = []
        searchProducts()
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Reset parameters
        self.dataProducts = []
        self.totalNumRecs = 0
        self.productsShowing = 0
        self.searchText = searchBar.text ?? ""
        pageNumber = 1
        myOrder = .predefined
        orderLabel.text = "Predefenido"
        searchProducts()
        
        self.view.endEditing(true)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsShowing != 0 ? self.productsShowing + 1 : 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productTableCell", for: indexPath) as? ProductTableCell else {
            return UITableViewCell()
        }
        
        if indexPath.row >= productsShowing {
            //Call services for next Page
            pageNumber = pageNumber + 1
            searchProducts()
            return UITableViewCell()
        }
        
        let productCell = self.dataProducts[indexPath.row]
        cell.configure(productData: productCell)
        return cell
    }
}


extension ViewController {
    
    func searchProducts() {
        
        let urlString = "https://shoppapp.liverpool.com.mx/appclienteservices/services/v3/plp"
        var parameters = ["search-string": searchText, "page-number": pageNumber] as [String : Any]
        
        if myOrder == .lowerPrice {
            parameters = ["search-string": searchText, "page-number": pageNumber, "sort-option": "minSortPrice|0"] as [String : Any]
        }
        if myOrder == .higherPrice {
            parameters = ["search-string": searchText, "page-number": pageNumber, "sort-option": "minSortPrice|1"] as [String : Any]
        }
        //print(parameters)
        
        AF.request(urlString, parameters: parameters)
                    .responseJSON(completionHandler: {response in
                        switch(response.result) {
                        case .success(_):
                            if let adnasdasd = response.data {
                                do{
                                    let allReplies = try JSONDecoder().decode(PlpResults.self, from: adnasdasd)
                                    if self.dataProducts.count > 0 {
                                        self.dataProducts.append(contentsOf: allReplies.plpResults.records)
                                    } else {
                                        self.dataProducts = allReplies.plpResults.records
                                    }
                                    
                                    self.totalNumRecs = allReplies.plpResults.plpState.totalNumRecs ?? 0
                                    self.productsShowing = allReplies.plpResults.plpState.lastRecNum ?? 0
                                    self.tableView.reloadData()
                                }catch {
                                    print("Error: \(error)")
                                }
                            }
                        case .failure(_):
                            print("Failure")
                        }
                    })
  }
}
