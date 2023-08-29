//
//  ProductListViewModel.swift
//  Product


import Foundation
import UIKit
import CoreData

class ProductListViewModel {
    
    var productList: [ProductListModel] = [ProductListModel]()
    var reloadTableView: (()->())?
    private var cellViewModels: [ProductListModel] = [ProductListModel]() {
        didSet {
            self.reloadTableView?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    func getCellViewModel( at indexPath: IndexPath ) -> ProductListModel {
        return cellViewModels[indexPath.row]
    }
    
    
    func fetchProductList() -> [ProductListModel]{
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [ProductListModel]() }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductList")

        do {
            let result = try managedContext.fetch(fetchRequest)
            var productList = [ProductListModel]()
            for data in result as! [NSManagedObject] {
                productList.append(ProductListModel(productID: data.value(forKey: "productID") as! Int, productName: data.value(forKey: "productName") as! String, productStock: data.value(forKey: "productStock") as! Double, productPrice: data.value(forKey: "productPrice") as! Double, productNotes: data.value(forKey: "productNotes") as! String, selectedQuantity: data.value(forKey: "selectedQuantity") as! Double))
                
            }
            cellViewModels = productList
            
        } catch {
            
            print("Failed")
        }
        return cellViewModels
    }
    
    func updateData(productName :String, productQuantityStock : Double, selectedQuantity: Double){
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "ProductList")
        fetchRequest.predicate = NSPredicate(format: "productName = %@", productName)
        do
        {
            let product = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = product[0] as! NSManagedObject
            objectUpdate.setValue(productQuantityStock, forKey: "productStock")
            objectUpdate.setValue(selectedQuantity, forKey: "selectedQuantity")
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
    }
    
}


