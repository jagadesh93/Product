//
//  ProductListViewController.swift
//  Product


import Foundation
import UIKit

class ProductListViewController: UIViewController {

   
    @IBOutlet weak var noProductFoundLabel: UILabel!
    @IBOutlet weak var productListTableView: UITableView!
    
    @IBOutlet weak var orderNowButton: UIButton!
    var productViewModel = ProductListViewModel()
    var productList = [ProductListModel]()
    var selectedProductList = [ProductListModel]()
    
    var selectedIndexPaths: [IndexPath] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()

    }
    
    func  setupUI(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        productListTableView.register(UINib.init(nibName: "ProductListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        productList =  productViewModel.fetchProductList()
        productListTableView.isHidden = productViewModel.numberOfCells == 0 ? true : false
        orderNowButton.isHidden = productViewModel.numberOfCells == 0 ? true : false
        noProductFoundLabel.isHidden = productViewModel.numberOfCells == 0 ? false : true
        productViewModel.reloadTableView = {
            DispatchQueue.main.async { self.productListTableView.reloadData() }
        }
        
    }
    
    @objc func addTapped() {
        
        let storyborad:UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let addProductVC = storyborad.instantiateViewController(withIdentifier: "AddProductViewController") as? AddProductViewController{
            self.navigationController?.pushViewController(addProductVC, animated: true)
        }
    }
    
    
    @IBAction func orderNowButtonTapped(_ sender: UIButton) {
        
        
        if self.selectedProductList.count == 0 {
            self.showAlert("Please select product to process your order ")
            return
        }
        
        var totalCost : Double = 0.0
        for i in 0..<selectedProductList.count {
            totalCost += self.selectedProductList[i].selectedQuantity * self.selectedProductList[i].productPrice
        }
        
        let alertMessage = "Orders is created with total : Rs \(totalCost)"
        
        self.showAlertWithOkAndCancel(title: "Order Process", message: alertMessage, okActionTitle: "OK", cancelActionTitle: "Cancel", okCompletion: {
            
            let uuid = UUID().uuidString
            var totalPrice : Double = 0.0
            print("Order ID : ",uuid)
            print("Items:")
            for i in 0..<self.selectedProductList.count {
                let selectedQty = String(format: "%.0f", self.selectedProductList[i].selectedQuantity)
                
                print("\(selectedQty)X",  self.selectedProductList[i].productName, "\(self.selectedProductList[i].selectedQuantity * self.selectedProductList[i].productPrice)" )
                totalPrice += self.selectedProductList[i].selectedQuantity * self.selectedProductList[i].productPrice
            }
            print("--------------------")
            print("Total ", totalPrice)
            
            for i in 0..<self.selectedProductList.count {
                self.productViewModel.updateData(productName: self.selectedProductList[i].productName, productQuantityStock: self.selectedProductList[i].productStock - self.selectedProductList[i].selectedQuantity, selectedQuantity: 0)
            }
            self.productList =  self.productViewModel.fetchProductList()
            self.selectedProductList.removeAll()
            self.deselectAllSelectedRows()
            self.productListTableView.reloadData()
        }, cancelCompletion: nil)

    }
    
    
    func deselectAllSelectedRows() {
        for indexPath in selectedIndexPaths {
            productListTableView.deselectRow(at: indexPath, animated: false)
        }
        selectedIndexPaths.removeAll()
    }
    

}

extension ProductListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productViewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTableViewCell") as? ProductListTableViewCell {
            let productList = productViewModel.getCellViewModel(at: indexPath)
            cell.setProductDetails(productList: productList)
            cell.incrementButton.tag = indexPath.row
            cell.decrementButton.tag = indexPath.row
            if cell.isSelected == false {
                cell.accessoryType = .none
            }
            if productList.productStock == 0 {
                cell.cellBgView.backgroundColor = .lightGray
                cell.isUserInteractionEnabled = false
            }
            else {
                cell.cellBgView.backgroundColor = .white
                cell.isUserInteractionEnabled = true
            }
            cell.incrementButton.addTarget(self, action: #selector(addQtyButtonTapped), for: .touchUpInside)
            cell.decrementButton.addTarget(self, action: #selector(reduceQtyButtonTappe), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    @objc  func addQtyButtonTapped(sender : UIButton) {
                
        var incrementQty = self.productList[sender.tag].selectedQuantity + 1
        incrementQty = incrementQty > self.productList[sender.tag].productStock ? self.productList[sender.tag].productStock : incrementQty
        self.productViewModel.updateData(productName: self.productList[sender.tag].productName, productQuantityStock: self.productList[sender.tag].productStock, selectedQuantity: incrementQty)
        self.productList =  self.productViewModel.fetchProductList()
        if (selectedProductList.count != 0) {
            if let index = selectedProductList.firstIndex(where: { $0.productName == productList[sender.tag].productName }) {
                selectedProductList[index].selectedQuantity = productList[sender.tag].selectedQuantity
            }
        }
        self.productListTableView.reloadData()
        
    }
    
    @objc  func reduceQtyButtonTappe(sender : UIButton) {
        var decrementQty = self.productList[sender.tag].selectedQuantity - 1
        decrementQty = decrementQty < 1 ? 1 : decrementQty
        self.productViewModel.updateData(productName: self.productList[sender.tag].productName, productQuantityStock: self.productList[sender.tag].productStock, selectedQuantity: decrementQty)
        self.productList =  self.productViewModel.fetchProductList()
        if (selectedProductList.count != 0) {
            if let index = selectedProductList.firstIndex(where: { $0.productName == productList[sender.tag].productName }) {
                selectedProductList[index].selectedQuantity = productList[sender.tag].selectedQuantity
            }
        }
        self.productListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndexPaths.append(indexPath)
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell!.isSelected
        {
            cell!.isSelected = false
            if cell!.accessoryType == .none
            {
                selectedProductList.append(productList[indexPath.row])
                cell!.accessoryType = .checkmark
            }
            else
            {
                if let index = selectedProductList.firstIndex(where: { $0.productName == productList[indexPath.row].productName }) {
                    selectedProductList.remove(at: index)
                    cell?.accessoryType = .none
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
}
