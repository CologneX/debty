//
//  PresentAlert.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 24/04/24.
//
import SwiftUI
func presentAlert(title: String, subTitle: String, primaryAction: UIAlertAction, secondaryAction: UIAlertAction? = nil) {
    DispatchQueue.main.async {
        let alertController = UIAlertController(title: title, message: subTitle, preferredStyle: .alert)
        alertController.addAction(primaryAction)
        if let secondary = secondaryAction {
            alertController.addAction(secondary)
        }
        rootController?.present(alertController, animated: true, completion: nil)
    }
}
