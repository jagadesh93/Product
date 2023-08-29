//
//  ProductListTableViewCell.swift
//  ProductList


import UIKit

class ProductListTableViewCell: UITableViewCell {
    @IBOutlet weak var productStockLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productNotesLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var incrementButton: UIButton!
    @IBOutlet weak var decrementButton: UIButton!
    
    @IBOutlet weak var cellBgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setProductDetails(productList: ProductListModel) {
        
        productNameLabel.text = productList.productName
        productStockLabel.text = "Product Stock : " + String(productList.productStock)
        productPriceLabel.text = "Product Price : " + String("Rs.\(productList.productPrice)")
        productNotesLabel.text = productList.productNotes
        quantityLabel.text = String(format: "%.0f", productList.selectedQuantity)
        
    }
    
}
