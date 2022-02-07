//
//  OperationsVC.swift
//  BankApp2
//
//  Created by Danil Ryumin on 07.02.2022.
//

import UIKit
import RealmSwift

class OperationsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setBackButtonToView()
    }
    
    private func setBackButtonToView() {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "backButton"), for: .normal)
        button.addTarget(self, action: #selector(handlerBackButton_Click), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    @objc func handlerBackButton_Click() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension OperationsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
      }
}

extension OperationsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = try! Realm()
        return realm.objects(Operation3.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realm = try! Realm()
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell", for: indexPath) as? OperationCell else { return UITableViewCell() }
        let objects = realm.objects(Operation3.self)
        cell.operationInfo.text = "\(objects[indexPath.row].name) for \(objects[indexPath.row].sum)$\n\(objects[indexPath.row].date)"
        return cell
    }
}
