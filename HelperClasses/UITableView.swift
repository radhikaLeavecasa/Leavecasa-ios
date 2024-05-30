//
//  UITableView.swift
//  Josh
//
//  Created by Esfera-Macmini on 29/03/22.
//

import UIKit

extension UITableView{
    
    func ragisterNib(nibName:String) {
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
}

extension UITableViewCell{
    func getIdentifier() -> String{
        return "\(self)"
    }
}
