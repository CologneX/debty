//
//  RootController.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 24/04/24.
//

import UIKit
var rootController: UIViewController? {
    guard let scene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first else { return nil }
  var currentViewController: UIViewController? = scene.windows.filter { $0.isKeyWindow }.first?.rootViewController

  while let presentedViewController = currentViewController?.presentedViewController {
    currentViewController = presentedViewController
  }

  return currentViewController
}
