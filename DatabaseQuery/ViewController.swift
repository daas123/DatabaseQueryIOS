//
//  ViewController.swift
//  DatabaseQuery
//
//  Created by Neosoft on 05/12/23.
//

import UIKit

class ViewController: UIViewController {
    let dbManager = DataBaseManager()
    var FetchedData : [UserEvent]?
    
    @IBOutlet weak var listTableView: UITableView!
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return picker
    }()
    
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtQuery: UITextField!
    
    @IBOutlet weak var lblResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        setupDatePicker()
    }
    
    
    func setupDatePicker() {
        txtDate.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickerDoneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        txtDate.inputAccessoryView = toolbar
    }
    
    @objc func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyy" // Set your desired date format
        txtDate.text = dateFormatter.string(from: datePicker.date)
    }
    @objc func datePickerDoneButtonPressed() {
        view.endEditing(true)
    }
    
    @IBAction func onAppend(_ sender: UIButton) {
        let userdata = userEvent(title: txtTitle.text ?? "", desc: txtDescription.text ?? "", date: txtDate.text ?? "")
        dbManager.saveData(user: userdata) { val in
            self.lblResult.text = val
            self.txtTitle.text = ""
            self.txtDate.text = ""
            self.txtDescription.text = ""
        }
    }
    
    @IBAction func onQueryFire(_ sender: UIButton) {
        dbManager.sendQuery(queryDate: txtQuery.text ?? "") { succ, val in
            if succ{
                self.lblResult.text = "data retrvived"
                self.FetchedData = val
                if self.FetchedData?.count != 0 {
                    self.listTableView.reloadData()
                }
                
            }else{
                print("there is some error ")
            }
        }
    }
}
extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        FetchedData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DateTableViewCell
        cell.lbldate.text = FetchedData?[indexPath.row].date
        return cell
    }
    
    
}

