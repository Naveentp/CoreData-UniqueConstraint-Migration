//
//  ViewController.swift
//  CoreDataUniqueConstraintMigration
//
//  Created by Naveen on 20/06/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        fetchUsers()
    }

    private func fetchUsers() {
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = UserEntity.fetchRequest()
            let result = try managedContext.fetch(fetchRequest)
            var text: String = ""
            for i in result {
                text = text + "Id: \(i.uniqueId ?? "nil"), Name: \(i.name!), Age: \(i.age)\n"
            }
            if(text.isEmpty) {
                text = "Click on + icon to add new user"
            }
            textView.text = text
        }catch {
            print(error)
        }
    }

    @IBAction func onAddClicked(_ sender: Any) {
        showAlert(controller: self)
    }

    func showAlert(controller: ViewController) {
        let alert = UIAlertController(title: "Add record to UserEntity", message: "If you want nil to be stored on UniqueIdentifier, leave the field blank", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.placeholder = "UniqueId"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Age"
            textField.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let idField = alert?.textFields![0].text
            let nameField = alert?.textFields![1].text
            let ageField = alert?.textFields![2].text
            if(nameField != nil && ageField != nil) {
                let age = Int32(ageField!) ?? 0
                controller.saveToDB(idField, nameField, age)
            }
        }))
        controller.present(alert, animated: true, completion: nil)
    }


    func saveToDB(_ id: String?, _ name: String?, _ age: Int32) {
        do {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            var identifier = id
            if id == "" || id == nil {
                identifier = nil
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            try UserEntity.saveRecord(id: identifier, name: name!, age: age, context: managedContext)
            fetchUsers()
        } catch {
            print(error)
        }
    }
}

