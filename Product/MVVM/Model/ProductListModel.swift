//
//  ProductListModel.swift
//  Product


import Foundation

class ProductListModel {
    var productID : Int
    var productName : String
    var productStock : Double
    var productPrice : Double
    var productNotes : String
    var selectedQuantity : Double
    
    init( productID: Int, productName: String, productStock: Double, productPrice: Double, productNotes: String, selectedQuantity : Double) {
        self.productID = productID
        self.productName = productName
        self.productStock = productStock
        self.productPrice = productPrice
        self.productNotes = productNotes
        self.selectedQuantity = selectedQuantity
    }
    
}
