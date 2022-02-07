//
//  AmountVCViewController.swift
//  BankApp2
//
//  Created by Danil Ryumin on 07.02.2022.
//

import UIKit

class AmountVC: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func ready_Click(_ sender: Any) {
        self.navigationController?.viewControllers.forEach { viewController in
            (viewController as? ViewController)?.dataFromAmountVC = textField.text ?? "" }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
          view.endEditing(true)
    }
}
