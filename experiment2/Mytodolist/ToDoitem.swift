//
//  ToDoitem.swift
//  Mytodolist
//
//  Created by nju on 2021/10/22.
//

import UIKit

class ToDoitem: NSObject,Encodable,Decodable {
    var title:String
    var isChecked:Bool
    
    init(title:String, isChecked:Bool)
    {
        self.isChecked = isChecked
        self.title = title
    }
    
}
