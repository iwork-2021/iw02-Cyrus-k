//
//  ItemViewController.swift
//  Mytodolist
//
//  Created by nju on 2021/10/22.
//

import UIKit

protocol AddItemDelegate{
    func addItem(item:ToDoitem)
}

protocol EditItemDelegate{
    func editItem(newitem:ToDoitem, itemIndex: Int)
}

class ItemViewController: UIViewController {

    @IBOutlet weak var isChecked: UISwitch!
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    
    var addItemDelegate:AddItemDelegate?
    var editItemDelegate:EditItemDelegate?
    var itemToEdit:ToDoitem?
    var itemIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doneButton.isEnabled = false
        if itemToEdit != nil{
            doneButton.isEnabled = true
            self.titleInput.text! = itemToEdit!.title
            self.isChecked.isOn = itemToEdit!.isChecked
        }
        
    }
    @IBAction func Closed(_ sender: Any) {
        if itemToEdit == nil{
            self.addItemDelegate?.addItem(item: ToDoitem(title: titleInput.text!, isChecked: isChecked.isOn))
        }
        else{
            self.editItemDelegate?.editItem(newitem: ToDoitem(title: titleInput.text!, isChecked: isChecked.isOn), itemIndex: self.itemIndex)
        }
        //self.addItemDelegate?.addItem(item: ToDoitem(title: titleInput.text!, isChecked: isChecked.isOn))
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Canceled(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ItemViewController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldtext = textField.text!
        let stringRange = Range(range, in:oldtext)!
        let newText = oldtext.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty
        return true
    }
}
