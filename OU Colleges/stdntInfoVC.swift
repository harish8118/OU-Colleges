//
//  stdntInfoVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 06/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class stdntInfoVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var stdnTF: UITextField!
    @IBOutlet weak var stdnSrchTbl: UITableView!
    @IBOutlet weak var semTF: UITextField!
    
    var coursePicker : UIPickerView!
    var pgrmData : NSArray!
    var semPicker : UIPickerView!
    var semData : NSArray!
    
    var stdntData : NSArray!

    var pgrm : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
           
        let dflts = UserDefaults.standard
        let clCde = dflts.value(forKey: "COLLCODE")
        print("pgrm:\(pgrm ?? "")")
        
        guard let gitUrl = URL(string: stdntPgrmApi + "\(clCde ?? 1051)&ProgramID=\(self.pgrm!)") else { return }
                        
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
        self.stdnTF.inputView = self.coursePicker
          
        self.semPicker = UIPickerView.init()
        self.semPicker.delegate = self
        self.semPicker.dataSource = self
        self.semTF.inputView = self.semPicker
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "SELECT", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.stdnTF.inputAccessoryView = toolBar5
        self.semTF.inputAccessoryView = toolBar5
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
        }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == self.coursePicker {
                return self.pgrmData?.count ?? 0
                
            }else if pickerView == self.semPicker {
                return self.semData?.count ?? 0
                
            }
           return 10
    }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
            if (pickerView==self.coursePicker) {
                let str = self.pgrmData?[row] as! NSDictionary
                
                return str.value(forKey: "COURSE") as? String
               
            }else if (pickerView==self.semPicker) {
                let str = self.semData?[row] as! NSDictionary
                
                return str.value(forKey: "ROLLNAME") as? String
               
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
                
                pickerLabel?.text = str.value(forKey: "COURSE") as? String
               
            }else if (pickerView==self.semPicker) {
                let str = self.semData?[row] as! NSDictionary
                
                pickerLabel?.text = str.value(forKey: "ROLLNAME") as? String
               
            }
           
           return pickerLabel!
           
       }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
           
            if pickerView == self.coursePicker {
                let str = self.pgrmData?[row] as! NSDictionary
                
                self.stdnTF.text = str.value(forKey: "COURSE") as? String
                self.stdnTF.tag = str.value(forKey: "COURSEID") as? NSNumber as! Int

            }else if pickerView == self.semPicker {
                let str = self.semData?[row] as! NSDictionary
                
                self.semTF.text = str.value(forKey: "ROLLNAME") as? String
                self.semTF.tag = str.value(forKey: "ROLLID") as? NSNumber as! Int

            }
           
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.stdntData?.count ?? 0>0 {
            return self.stdntData?.count ?? 0
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "srchStdnt", for: indexPath) as! clgCell
        
        rtrn.indxLbl.text = "\(indexPath.row+1)."
        
        let str = self.stdntData?[indexPath.row] as! NSDictionary
        
        rtrn.nameLbl.text = "\(str.value(forKey: "SName") ?? " ")"
        rtrn.mblLbl.text = "\(str.value(forKey: "HTNo") ?? " ")"
        
        
        return rtrn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc:stdntDtlVC = self.storyboard?.instantiateViewController(withIdentifier: "stdntDtlVC") as! stdntDtlVC
        vc.infoData = self.stdntData?[indexPath.row] as? NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func goAct(_ sender: UIButton) {
        guard self.stdnTF.text?.count ?? 0>0 else {
            let alert = UIAlertController(title: "Alert", message: "Please select valid course.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.semTF.text?.count ?? 0>0 else {
            let alert = UIAlertController(title: "Alert", message: "Please select valid semester.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if self.stdnTF.text?.count ?? 0>0 && self.semTF.text?.count ?? 0>0 {
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
               
            let dflts = UserDefaults.standard
            let clCde = dflts.value(forKey: "COLLCODE")
            
            guard let gitUrl = URL(string: stdntDataApi + "\(clCde ?? 1051)&PROGRAMID=\(self.pgrm!)&COURSEID=\(self.stdnTF.tag)&CURRENTROLLID=\(self.semTF.tag)") else { return }
                            
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
                                    
                    self.stdntData = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                    print("res:\(self.stdntData)")
                    
                    DispatchQueue.main.async {
                        
                        if self.stdntData?.count ?? 0>0 {
                        loadingView.hide()
                            self.stdnSrchTbl.isHidden = false
                            self.semTF.resignFirstResponder()
                        self.stdnSrchTbl.reloadData()
                                                        
                    }else {
                            self.stdnSrchTbl.isHidden = true
                            
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
        }
        
    }
    
    

    @objc func resign(){
        self.stdnTF.resignFirstResponder()
        self.semTF.resignFirstResponder()
        
        if self.stdnTF.text?.count ?? 0>0 {
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
               
            let dflts = UserDefaults.standard
            let clCde = dflts.value(forKey: "COLLCODE")
            
            guard let gitUrl = URL(string: stdntSemApi + "\(clCde ?? 1051)&ProgramID=\(self.pgrm!)&CourseID=\(self.stdnTF.tag)") else { return }
                            
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
                                    
                    self.semData = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                    print("res:\(self.semData)")
                    
                    DispatchQueue.main.async {
                        
                        if self.semData?.count ?? 0>0 {
                        loadingView.hide()
                        self.semPicker.reloadAllComponents()
                                                        
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
        }
    }
    
    @IBAction func homeAct(_ sender: UIBarButtonItem) {
        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
