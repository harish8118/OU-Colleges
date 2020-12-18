//
//  postAlrtVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 09/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import Loaf

class postAlrtVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var msgTF: UITextField!
    @IBOutlet weak var toTF: UITextField!
    @IBOutlet weak var prtyTF: UITextField!
    @IBOutlet weak var sbjcTF: UITextField!
    @IBOutlet weak var cntnTF: UITextView!
    
    var msgPicker : UIPickerView!
    var toPicker : UIPickerView!
    var prityPicker : UIPickerView!
    var grpPicker : UIPickerView!
    var clgPicker : UIPickerView!
    
    var grpTF : UITextField!
    @IBOutlet weak var clgLbl: UILabel!
    var clgTF : UITextField!
    
    var msgData : NSArray!
    var toData : NSArray!
    var grpData : NSArray!
    var clgData : NSArray!
    
    var clCde : String!
    
    let dasArr = ["HIGH","LOW","MEDIUM"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.clgTF.delegate = self
  //      self.grpTF.delegate = self

        
        
        self.msgPicker = UIPickerView.init()
        self.msgPicker.delegate = self
        self.msgPicker.dataSource = self
        self.msgTF.inputView = self.msgPicker
          
        self.toPicker = UIPickerView.init()
        self.toPicker.delegate = self
        self.toPicker.dataSource = self
        self.toTF.inputView = self.toPicker
        
        self.prityPicker = UIPickerView.init()
        self.prityPicker.delegate = self
        self.prityPicker.dataSource = self
        self.prtyTF.inputView = self.prityPicker
        
        self.clgPicker = UIPickerView.init()
        self.clgPicker.delegate = self
        self.clgPicker.dataSource = self
        //self.clgTF.inputView = self.clgPicker
        
        self.grpPicker = UIPickerView.init()
        self.grpPicker.delegate = self
        self.grpPicker.dataSource = self
        //self.grpTF.inputView = self.clgPicker
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "SELECT", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.msgTF.inputAccessoryView = toolBar5
        self.toTF.inputAccessoryView = toolBar5
        self.prtyTF.inputAccessoryView = toolBar5
        
        let toolBar : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar.tintColor = UIColor.black
        let done : UIBarButtonItem = UIBarButtonItem.init(title: "DONE", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems(NSArray(objects: space,done) as? [UIBarButtonItem], animated: true)
        self.sbjcTF.inputAccessoryView = toolBar
        self.cntnTF.inputAccessoryView = toolBar
        
        self.msgTF.layer.cornerRadius = 20.0
        self.msgTF.layer.borderWidth = 1.0
        self.msgTF.layer.masksToBounds = true;
        
        self.toTF.layer.cornerRadius = 20.0
        self.toTF.layer.borderWidth = 1.0
        self.toTF.layer.masksToBounds = true;
        
        self.prtyTF.layer.cornerRadius = 20.0
        self.prtyTF.layer.borderWidth = 1.0
        self.prtyTF.layer.masksToBounds = true;
        
        self.sbjcTF.layer.cornerRadius = 20.0
        self.sbjcTF.layer.borderWidth = 1.0
        self.sbjcTF.layer.masksToBounds = true;
        
        self.cntnTF.layer.cornerRadius = 20.0
        self.cntnTF.layer.borderWidth = 1.0
        self.cntnTF.layer.masksToBounds = true;
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        
      //  DispatchQueue.main.sync {
            
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: self.view)
        
        guard let gitUrl = URL(string: msgApi) else { return }
                        
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
            if let err = error {
                print("err:\(err)")
                //semaphore.signal()
                Loaf("Something went wrong.Try again.", state: .info, sender: self).show()
            }
                
            guard let data = data else {
                //semaphore.signal()
                return }
            do {
                                
                self.msgData = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                print("res:\(self.msgData)")
                
                DispatchQueue.main.async {
                    
                    if self.msgData?.count ?? 0>0 {
                    loadingView.hide()
                    self.msgPicker.reloadAllComponents()
                    //semaphore.signal()
                                                    
                }else {
                    loadingView.hide()
                    Loaf("No Data Found..", state: .info, sender: self).show()
                }
                    
                }
                                
            } catch let err {
                print(err.localizedDescription)
               // semaphore.signal()
                loadingView.hide()
                Loaf("Something went wrong.Try again.", state: .warning, sender: self).show()
                
                }
            }.resume()
            
           // semaphore.wait()
            
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: self.view)
            
            guard let gitUrl2 = URL(string: toApi) else { return }
                            
                URLSession.shared.dataTask(with: gitUrl2) { (data, response
                                , error) in
                if let err = error {
                    print("err:\(err)")
                 //   semaphore.signal()
                    Loaf("Something went wrong.Try again.", state: .info, sender: self).show()
                }
                    
                guard let data = data else { return }
                do {
                                    
                    self.toData = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                    print("res:\(self.toData)")
                    
                    DispatchQueue.main.async {
                        
                        if self.toData?.count ?? 0>0 {
                        loadingView.hide()
                        self.toPicker.reloadAllComponents()
                        //semaphore.signal()
                                                        
                    }else {
                        loadingView.hide()
                        Loaf("No Data Found..", state: .info, sender: self).show()
                    }
                        
                    }
                                    
                } catch let err {
                    print(err.localizedDescription)
                   // semaphore.signal()
                    loadingView.hide()
                    Loaf("Something went wrong.Try again.", state: .warning, sender: self).show()
                    
                    }
                }.resume()
                
                //semaphore.wait()
            
        //}
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
        }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == self.msgPicker {
                return self.msgData?.count ?? 0
                
            }else if pickerView == self.toPicker {
                return self.toData?.count ?? 0
                
            }else if pickerView == self.prityPicker {
                return self.dasArr.count
                
            }else if pickerView == self.clgPicker {
                return self.clgData?.count ?? 0
                
            }else if pickerView == self.grpPicker {
                return self.grpData.count
                
            }
        
           return 10
    }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
            if (pickerView==self.msgPicker) {
                let str = self.msgData?[row] as! NSDictionary
                
                return str.value(forKey: "Messagetypename") as? String
               
            }else if (pickerView==self.toPicker) {
                let str = self.toData?[row] as! NSDictionary
                
                return str.value(forKey: "AlertToname") as? String
               
            }else if (pickerView==self.prityPicker) {
    
                return "\(self.dasArr[row])"
               
            }else if (pickerView==self.clgPicker) {
                let str = self.clgData?[row] as! NSDictionary
                        
                return "\(str.value(forKey: "CollCode") ?? "")-\(str.value(forKey: "CollName") ?? "")"
                       
            }else if (pickerView==self.grpPicker) {
                let str = self.grpData?[row] as! NSDictionary
                        
                return str.value(forKey: "GROUPNAME") as? String
                       
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

    
            if (pickerView==self.msgPicker) {
                let str = self.msgData?[row] as! NSDictionary
                pickerLabel?.text = str.value(forKey: "Messagetypename") as? String
               
            }else if (pickerView==self.toPicker) {
                let str = self.toData?[row] as! NSDictionary
                pickerLabel?.text = str.value(forKey: "AlertToname") as? String
               
            }else if (pickerView==self.prityPicker) {
                pickerLabel?.text = "\(self.dasArr[row])"
               
            }else if (pickerView==self.clgPicker) {
                let str = self.clgData?[row] as! NSDictionary
                pickerLabel?.text = "\(str.value(forKey: "CollCode") ?? "")-\(str.value(forKey: "CollName") ?? "")"
               
            }else if (pickerView==self.grpPicker) {
                let str = self.grpData?[row] as! NSDictionary
                pickerLabel?.text = str.value(forKey: "GROUPNAME") as? String
               
            }
           
           return pickerLabel!
           
       }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
           
            if pickerView == self.msgPicker {
                let str = self.msgData?[row] as! NSDictionary
                
                self.msgTF.text = str.value(forKey: "Messagetypename") as? String
                self.msgTF.tag = str.value(forKey: "MTID") as? NSNumber as! Int

            }else if pickerView == self.toPicker {
                let str = self.toData?[row] as! NSDictionary
                
                self.toTF.text = str.value(forKey: "AlertToname") as? String
                self.toTF.tag = str.value(forKey: "TID") as? NSNumber as! Int
                self.clgLbl.isHidden = true
                
                if self.toTF.tag == 2 {
                    self.clgCdes()
                    
                }else if self.toTF.tag == 6 {
                    self.grps()
                }

            }else if pickerView == self.prityPicker {
                self.prtyTF.text = "\(self.dasArr[row])"
                
            }else if pickerView == self.clgPicker {
                let str = self.clgData?[row] as! NSDictionary
                self.clCde = "\(str.value(forKey: "CollCode") ?? "" )"
                self.clgLbl.isHidden = false
                self.clgLbl.text = "College Code:- \(str.value(forKey: "CollCode") ?? "" )"
                
                
                
            }else if pickerView == self.grpPicker {
                let str = self.grpData?[row] as! NSDictionary
                self.clCde = "\(str.value(forKey: "RowID") ?? "" )"
                self.clgLbl.isHidden = false
                self.clgLbl.text = "Group:- \(str.value(forKey: "GROUPNAME") ?? "" )"
            }
           
       }
    
    @IBAction func postAct(_ sender: UIButton) {
        guard self.msgTF.text?.count ?? 0>0 else {
            let alert = UIAlertController(title: "Alert", message: "Please select valid messsage type.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.toTF.text?.count ?? 0 > 0 else {
            let alert = UIAlertController(title: "Alert", message: "Please select valid to field.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.prtyTF.text?.count ?? 0 > 0 else {
            let alert = UIAlertController(title: "Alert", message: "Please select valid message priority.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.sbjcTF.text?.count ?? 0 > 0 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid subject.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.cntnTF.text?.count ?? 0 > 0 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid content.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if self.msgTF.text?.count ?? 0>0 && self.toTF.text?.count ?? 0>0 && self.prtyTF.text?.count ?? 0>0 && self.sbjcTF.text?.count ?? 0>0 && self.cntnTF.text?.count ?? 0>0 {
          
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
            
        let dflts = UserDefaults.standard
        let clID = dflts.value(forKey: "CLID")
        
        //create the url with URL
        let url = URL(string: postAlrtApi + "\(self.msgTF.tag )&TID=\(self.toTF.tag)&CollCode=\(self.clCde ?? "")&Msg_Priority=\(self.prtyTF.text ?? "")&Msg_Subject=\(self.sbjcTF.text ?? "")&MessageContent=\(self.cntnTF.text ?? "")&SenderID=\(clID ?? "")")! //change the url

        let session = URLSession.shared

        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POS

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

        DispatchQueue.main.sync {
            
            do {
                //create json object from data
            
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                print("res:\(jsonResponse)")
            
            DispatchQueue.main.async {
                
            if jsonResponse.value(forKey: "StatusID") as? NSNumber == 1 {
                loadingView.hide()
                Loaf("Alert Created Ssuccessfully.", state: .success, sender: self).show()
                
                self.navigationController?.popViewController(animated: true)
            
                                        
            }else {
                loadingView.hide()
                Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                
            }
            }
            } catch let error {
                print(error.localizedDescription)
                loadingView.hide()
            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()

            }
        }
        })
        task.resume()
        
        }else {
            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()

        }
    }
    
    func clgCdes(){
            
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: self.view)
        
        guard let gitUrl = URL(string: clgApi) else { return }
                        
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
            if let err = error {
                print("err:\(err)")
                Loaf("Something went wrong.Try again.", state: .info, sender: self).show()
            }
                
            guard let data = data else { return }
            do {
                                
                self.clgData = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                print("res:\(self.clgData)")
                
                DispatchQueue.main.async {
                    
                    if self.clgData?.count ?? 0>0 {
                    loadingView.hide()
                    self.clgPicker.reloadAllComponents()
                    
                    let alert = UIAlertController(title: "Select College", message: "Please select College below list. ", preferredStyle: .alert)
                    alert.addTextField { (textField) in
                        textField.placeholder = "--Select College--"
                        textField.inputView = self.clgPicker
                    }

                    alert.addAction(UIAlertAction(title: "SELECT", style: .default, handler: { [weak alert] (_) in
                        let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                        
                        print("Text field: \(textField?.text ?? "")")
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))

                    self.present(alert, animated: true, completion: nil)
                                                    
                }else {
                    loadingView.hide()
                    Loaf("No Data Found..", state: .info, sender: self).show()
                }
                    
                }
                                
            } catch let err {
                print(err.localizedDescription)
                loadingView.hide()
                Loaf("Something went wrong.Try again.", state: .warning, sender: self).show()
                
                }
            }.resume()
        
    }
    
    func grps(){
    
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: self.view)
        
        guard let gitUrl = URL(string: prityApi) else { return }
                        
            URLSession.shared.dataTask(with: gitUrl) { (data, response
                            , error) in
            if let err = error {
                print("err:\(err)")
                Loaf("Something went wrong.Try again.", state: .info, sender: self).show()
            }
                
            guard let data = data else { return }
            do {
                                
                self.grpData = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                print("res:\(self.grpData)")
                
                DispatchQueue.main.async {
                    
                    if self.grpData?.count ?? 0>0 {
                    loadingView.hide()
                    self.grpPicker.reloadAllComponents()
                        
                    let alert = UIAlertController(title: "Select Group", message: "Please select valid group. ", preferredStyle: .alert)
                    alert.addTextField { (textField) in
                        textField.placeholder = "--SELECT GROUP--"
                        textField.inputView = self.grpPicker
                    }

                    alert.addAction(UIAlertAction(title: "SELECT", style: .default, handler: { [weak alert] (_) in
                        let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                        
                        print("Text field: \(textField?.text ?? "")")
                        
                        }))
                        
                        alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))

                        self.present(alert, animated: true, completion: nil)
                                                    
                }else {
                    loadingView.hide()
                    Loaf("No Data Found..", state: .info, sender: self).show()
                }
                    
                }
                                
            } catch let err {
                print(err.localizedDescription)
                loadingView.hide()
                Loaf("Something went wrong.Try again.", state: .warning, sender: self).show()
                
                }
            }.resume()
            
            
    }
    
    @objc func resign(){
        self.msgTF.resignFirstResponder()
        self.toTF.resignFirstResponder()
        self.prtyTF.resignFirstResponder()
        self.sbjcTF.resignFirstResponder()
        self.cntnTF.resignFirstResponder()
    }

}
