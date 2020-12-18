//
//  facultyVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 01/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class facultyVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var pgrmTF: UITextField!
    @IBOutlet weak var fcltyTbl: UITableView!
    @IBOutlet weak var fcltyHed: UILabel!
    
    var coursePicker : UIPickerView!
    var pgrmData : NSArray!
    var fcltyData : NSArray!
    var pgrmId : NSNumber!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
           
        let dflts = UserDefaults.standard
        let clCde = dflts.value(forKey: "COLLCODE")
        
        guard let gitUrl = URL(string: pgrmApi + "\(clCde ?? 1051)") else { return }
                        
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
            
            if let err = error {
                print("err:\(err)")
                let alert = UIAlertController(title: "Alert", message: "No internet is available. Please connect to network.", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
                
            guard let data = data else { return }
            do {
                                
                self.pgrmData = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                print("res:\(self.pgrmData)")
                
                DispatchQueue.main.async {
                    
                    if self.pgrmData?.count ?? 0>0 {
                    loadingView.hide()
                    self.coursePicker.reloadAllComponents()
                                                    
                }else {
                    loadingView.hide()
                    //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                    
                    let alert = UIAlertController(title: "Alert", message: "No Data Found.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                    
                }
                                
            } catch let err {
                print(err.localizedDescription)
                    loadingView.hide()
                //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                                        
                let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                }
            }.resume()
        
        self.coursePicker = UIPickerView.init()
        self.coursePicker.delegate = self
        self.coursePicker.dataSource = self
        self.pgrmTF.inputView = self.coursePicker
          
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "SELECT", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.pgrmTF.inputAccessoryView = toolBar5
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
        }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == self.coursePicker {
                return self.pgrmData?.count ?? 0
                
            }
           return 10
    }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
            if (pickerView==self.coursePicker) {
                let str = self.pgrmData?[row] as! NSDictionary
                
                return str.value(forKey: "Program") as? String
               
            }
            return "-- NO DATA --"
       }
       
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
    
           var pickerLabel = view as? UILabel;

           if (pickerLabel == nil)
           {
               pickerLabel = UILabel()

               pickerLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
               pickerLabel?.textAlignment = NSTextAlignment.center
           }

    
            if (pickerView==self.coursePicker) {
                let str = self.pgrmData?[row] as! NSDictionary
                
                pickerLabel?.text = str.value(forKey: "Program") as? String
               
            }
           
           return pickerLabel!
           
       }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
           
            if pickerView == self.coursePicker {
                let str = self.pgrmData?[row] as! NSDictionary
                
                self.pgrmTF.text = str.value(forKey: "Program") as? String
                self.pgrmId = str.value(forKey: "ProgramId") as? NSNumber

            }
           
       }
    
    @IBAction func goAct(_ sender: UIButton) {
        if self.pgrmTF.text?.count ?? 0>0 {
            
            self.pgrmTF.resignFirstResponder()
            
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
           
        let dflts = UserDefaults.standard
        let clCde = dflts.value(forKey: "COLLCODE")
        
        guard let gitUrl = URL(string: fcltyApi + "\(clCde ?? 1051)&PROGRAMID=\(self.pgrmId ?? 1)") else { return }
                        
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
            
            if let err = error {
                print("err:\(err)")
                let alert = UIAlertController(title: "Alert", message: "No internet is available. Please connect to network.", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
                
            guard let data = data else { return }
            do {
                                
                self.fcltyData = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                print("res:\(self.fcltyData)")
                
                DispatchQueue.main.async {
                    
                    if self.pgrmData?.count ?? 0>0 {
                    loadingView.hide()
                        self.fcltyHed.isHidden = false
                        self.fcltyTbl.isHidden = false
                    self.fcltyTbl.reloadData()
                                                    
                }else {
                    loadingView.hide()
                    //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                    self.fcltyHed.isHidden = true
                    self.fcltyTbl.isHidden = true
                        
                    let alert = UIAlertController(title: "Alert", message: "No Data Found.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                    
                }
                                
            } catch let err {
                print(err.localizedDescription)
                    loadingView.hide()
                //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                                        
                let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                }
            }.resume()
            
        }else {
            let alert = UIAlertController(title: "Alert", message: "Please select program to proceed.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.fcltyData?.count ?? 0>0 {
            return self.fcltyData?.count ?? 0
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "fclty", for: indexPath) as! clgCell
        
        rtrn.indxLbl.text = "\(indexPath.row+1)."
        
        let str = self.fcltyData?[indexPath.row] as! NSDictionary
        
        rtrn.mblLbl.text = str.value(forKey: "MOBILENUMBER") as? String
        rtrn.nameLbl.text = str.value(forKey: "MEMBERNAME") as? String
        rtrn.ageLbl.text = "\(str.value(forKey: "TOTALEXP") ?? "")"
        
        return rtrn
    }
    
    @objc func resign() {
        self.pgrmTF.resignFirstResponder()
    }
    

}
