//
//  Extension.swift
//  Product


import Foundation
import UIKit

extension UIViewController {
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithOkAndCancel(title: String, message: String, okActionTitle: String = "OK", cancelActionTitle: String = "Cancel", okCompletion: (() -> Void)? = nil, cancelCompletion: (() -> Void)? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okActionTitle, style: .default) { _ in
            okCompletion?()
        }
        alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel) { _ in
            cancelCompletion?()
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
