//
//  Model.swift
//  BankApp2
//
//  Created by Danil Ryumin on 07.02.2022.
//

import RealmSwift
import Foundation

class Operation3: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var sum: Float = 0.0
    @objc dynamic var date: String = ""
}
