//
//  ViewController.swift
//  BankApp2
//
//  Created by Danil Ryumin on 07.02.2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var currentBalanceLabel: UILabel!
    
    var currentBalance: Float = 0
    var currentTransaction: Transaction!
    var dataFromAmountVC: String = ""
    var userDeafaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentBalance = userDeafaults.float(forKey: "currentBalance")
        updateBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataFromAmountVC = dataFromAmountVC.replacingOccurrences(of: ",", with: ".")
        
        let operation = Operation3()
        switch currentTransaction {
        case .withdrawCash:
            if dataFromAmountVC != "" {
                if currentBalance >= Float(dataFromAmountVC)! {
                    currentBalance -= Float(dataFromAmountVC)!
                    userDeafaults.set(currentBalance, forKey: "currentBalance")
                    updateOperation(operation, "Withdraw cash", "-", Float(dataFromAmountVC)!, Date().formatted())
                } else {
                    resetOperation()
                    errorAlert()
                }
            }
        case .topUpDeposit:
            if dataFromAmountVC != "" {
                currentBalance += Float(dataFromAmountVC)!
                userDeafaults.set(currentBalance, forKey: "currentBalance")
                updateOperation(operation, "Top up deposit", "+", Float(dataFromAmountVC)!, Date().formatted())
            }
        case .topUpPhone:
            if dataFromAmountVC != "" {
                if currentBalance >= Float(dataFromAmountVC)! {
                    currentBalance -= Float(dataFromAmountVC)!
                    userDeafaults.set(currentBalance, forKey: "currentBalance")
                    updateOperation(operation, "Top up phone", "-", Float(dataFromAmountVC)!, Date().formatted())
                } else {
                    resetOperation()
                    errorAlert()
                }
            }
        default: break
        }
        
        writeToRealm(operation)
        resetOperation()
        updateBalance()
    }

    @IBAction func withdrawCash_Click(_ sender: Any) {
        pushToAmountVC()
        currentTransaction = .withdrawCash
    }
    
    @IBAction func topUpDeposit_Click(_ sender: Any) {
        pushToAmountVC()
        currentTransaction = .topUpDeposit
    }
    
    @IBAction func topUpPhone_Click(_ sender: Any) {
        pushToAmountVC()
        currentTransaction = .topUpPhone
    }
    
    @IBAction func operationHistory_Click(_ sender: Any) {
        pushToOperationsVC()
    }
    
    func pushToAmountVC() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AmountVC") as? AmountVC else { return }
        guard let navigator = navigationController else { return }
        navigator.pushViewController(viewController, animated: true)
    }
    
    func pushToOperationsVC() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OperationsVC") as? OperationsVC else { return }
        guard let navigator = navigationController else { return }
        navigator.pushViewController(viewController, animated: true)
    }
    
    func updateBalance() {
        currentBalanceLabel.text = "Current balance: \(userDeafaults.float(forKey: "currentBalance"))$"
    }
    
    func updateOperation(_ operation: Operation3, _ name: String, _ type: String, _ sum: Float, _ date: String) {
        operation.name = name
        operation.type = type
        operation.sum = sum
        operation.date = date
    }
    
    func writeToRealm(_ operation: Operation3) {
        let realm = try! Realm()
        
        if dataFromAmountVC != "" {
            do {
                try realm.write({
                    realm.add(operation)
                })
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func errorAlert() {
        let alert = UIAlertController(title: "ERROR", message: "Not enough money", preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OK)
        present(alert, animated: true)
    }
    
    func resetOperation() {
        currentTransaction = nil
        dataFromAmountVC = ""
    }
}

enum Transaction {
    case withdrawCash
    case topUpDeposit
    case topUpPhone
}
