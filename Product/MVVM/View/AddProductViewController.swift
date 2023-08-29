//
//  AddProductViewController.swift
//  Product


import Foundation
import UIKit
import CoreData

class AddProductViewController: UIViewController {
    
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productStoctTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var AddButton: UIButton!
    @IBOutlet weak var CancleButton: UIButton!
    var productViewModel = ProductListViewModel()
    var productModel = [ProductListModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        
    }
    
    func setupUI() {
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        notesTextView.layer.borderWidth = 0.5
        notesTextView.layer.borderColor = borderColor.cgColor
        notesTextView.layer.cornerRadius = 5.0
        productModel = productViewModel.fetchProductList()
    }
    
    @IBAction func AddButtonAction(_ sender: UIButton) {
        
        if productNameTextField.text == ""{
            self.showAlert("Enter product name")
        }
        else if productStoctTextField.text == "" {
            self.showAlert("Enter product stock")
        }
        else if productPriceTextField.text == "" {
            self.showAlert("Enter product ptice")
        }
        else if productModel.contains(where: { $0.productName == productNameTextField.text }) {
            self.showAlert("product already exist")
        }
        else {
            createData()
        }
        
    }
    
    @IBAction func CancleButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func createData(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let productList = NSEntityDescription.entity(forEntityName: "ProductList", in: managedContext)!
        
        let product = NSManagedObject(entity: productList, insertInto: managedContext)
        product.setValue(Int.random(in: 1 ... 100), forKey: "productID")
        product.setValue(productNameTextField.text, forKey: "productName")
        product.setValue(Double(productStoctTextField.text ?? "0"), forKey: "productStock")
        product.setValue(Double(productPriceTextField.text ?? "0"), forKey: "productPrice")
        product.setValue(notesTextView.text, forKey: "productNotes")
        product.setValue(Double(1), forKey: "selectedQuantity")
        
        
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

extension AddProductViewController : UITextFieldDelegate,UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          textField.resignFirstResponder()
       }
    
}
