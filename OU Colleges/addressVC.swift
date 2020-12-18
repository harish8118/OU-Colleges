//
//  addressVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 05/11/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class addressVC: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {

    @IBOutlet weak var pricplTF: UITextField!
    @IBOutlet weak var mblTF: UITextField!
    @IBOutlet weak var adrssTF: UITextView!
    @IBOutlet weak var distTF: UITextField!
    @IBOutlet weak var mndlTF: UITextField!
    @IBOutlet weak var pinTF: UITextField!
    
    @IBOutlet weak var pincplErr: UILabel!
    @IBOutlet weak var mblErr: UILabel!
    @IBOutlet weak var adrssErr: UILabel!
    @IBOutlet weak var distErr: UILabel!
    @IBOutlet weak var mndlErr: UILabel!
    @IBOutlet weak var pinErr: UILabel!
    
    var distPicker : UIPickerView!
    var distData : NSArray!
    var mndlPicker : UIPickerView!
    var mndlData : NSArray!
    var stat : intmax_t!
    var clgData : NSDictionary!
    
    @IBOutlet weak var submitBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pricplTF.layer.cornerRadius = 20.0
        self.pricplTF.layer.borderWidth = 1.0
        self.pricplTF.layer.masksToBounds = true;
        
        self.mblTF.layer.cornerRadius = 20.0
        self.mblTF.layer.borderWidth = 1.0
        self.mblTF.layer.masksToBounds = true;
        
        self.adrssTF.layer.cornerRadius = 20.0
        self.adrssTF.layer.borderWidth = 1.0
        self.adrssTF.layer.masksToBounds = true;
        
        self.distTF.layer.cornerRadius = 20.0
        self.distTF.layer.borderWidth = 1.0
        self.distTF.layer.masksToBounds = true;
        
        self.mndlTF.layer.cornerRadius = 20.0
        self.mndlTF.layer.borderWidth = 1.0
        self.mndlTF.layer.masksToBounds = true;
        
        self.pinTF.layer.cornerRadius = 20.0
        self.pinTF.layer.borderWidth = 1.0
        self.pinTF.layer.masksToBounds = true;
        
        self.submitBttn.layer.cornerRadius = 8.0
        self.submitBttn.layer.masksToBounds = true;
       
        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.navigationBar.isHidden = false
        
        self.distPicker = UIPickerView.init()
        self.distPicker.delegate = self
        self.distPicker.dataSource = self
        self.distTF.inputView = self.distPicker
          
        self.mndlPicker = UIPickerView.init()
        self.mndlPicker.delegate = self
        self.mndlPicker.dataSource = self
        self.mndlTF.inputView = self.mndlPicker
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.pinTF.inputAccessoryView = toolBar5
        self.pricplTF.inputAccessoryView = toolBar5
        self.mblTF.inputAccessoryView = toolBar5
        self.adrssTF.inputAccessoryView = toolBar5
        self.distTF.inputAccessoryView = toolBar5
        self.mndlTF.inputAccessoryView = toolBar5
        
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)

        
        guard let gitUrl = URL(string: distApi) else { return }
                        
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
                                
                self.distData = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                print("res:\(self.distData)")
                
                DispatchQueue.main.async {
                    
                    if self.distData?.count ?? 0>0 {
                    loadingView.hide()
                    self.distPicker.reloadAllComponents()
                                                    
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
        
        if stat == 1 {
           self.navigationItem.setHidesBackButton(false, animated:true)
            
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
               
            let dflts = UserDefaults.standard
            let clCde = dflts.value(forKey: "COLLCODE")
            let pgid = "\(dflts.value(forKey: "ProgramID") ?? "")"
            let ROLEID = "\(dflts.value(forKey: "ROLEID") ?? "")"
            
            guard let gitUrl = URL(string: clgPrflAPI + "\(clCde ?? 1051)&ProgramID=\(pgid)") else { return }
                            
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
                                    
                    self.clgData = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                    print("res:\(self.clgData)")
                    
                    DispatchQueue.main.async {
                        
                        if self.clgData?.count ?? 0>0 {
                        loadingView.hide()
                            
                            self.pricplTF.text = "\(self.clgData?.value(forKey: "cPrincipalName") ?? "")"
                            
                            self.mblTF.text = "\(self.clgData?.value(forKey: "cMobileNo") ?? "")"

                            self.distTF.text = "\(self.clgData?.value(forKey: "cDistrict") ?? "")"

                            self.mndlTF.text = "\(self.clgData?.value(forKey: "cVillageMandal") ?? "")"
                            
                            self.pinTF.text = "\(self.clgData?.value(forKey: "cPinCode") ?? "")"
  
                            self.adrssTF.text = "\(self.clgData?.value(forKey: "cStreet") ?? "")"
                        
                                                        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

          if textField==self.pinTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.pinTF.text?.count ?? 0<6) || string == "" {
                
                return true
            }else{
                return false
            }
            
        }else if textField==self.mblTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.mblTF.text?.count ?? 0<10) || string == "" {
                
                return true
            }else{
                return false
            }
        }

        
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
        }
       
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == self.distPicker {
                return self.distData?.count ?? 0
                
            }else if pickerView == self.mndlPicker {
                return self.mndlData?.count ?? 0
                
            }
           return 10
    }
       
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
            if (pickerView==self.distPicker) {
                let str = self.distData?[row] as! NSDictionary
                
                return str.value(forKey: "DistrictName") as? String
               
            }else if (pickerView==self.mndlPicker) {
                let str = self.mndlData?[row] as! NSDictionary
                
                return str.value(forKey: "MandalName") as? String
               
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

    
            if (pickerView==self.distPicker) {
                let str = self.distData?[row] as! NSDictionary
                
                pickerLabel?.text = str.value(forKey: "DistrictName") as? String
               
            }else if (pickerView==self.mndlPicker) {
                let str = self.mndlData?[row] as! NSDictionary
                
                pickerLabel?.text = str.value(forKey: "MandalName") as? String
               
            }
           
           return pickerLabel!
           
       }
       
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
           
            if pickerView == self.distPicker {
                let str = self.distData?[row] as! NSDictionary
                
                self.distTF.text = str.value(forKey: "DistrictName") as? String
                self.distTF.tag = str.value(forKey: "DID") as? NSNumber as! Int
                self.mndlTF.text = ""
            }else if pickerView == self.mndlPicker {
                let str = self.mndlData?[row] as! NSDictionary
                
                self.mndlTF.text = str.value(forKey: "MandalName") as? String
                self.mndlTF.tag = str.value(forKey: "MID") as? NSNumber as! Int

            }
           
       }

    @IBAction func submitAct(_ sender: UIButton) {
        guard self.pricplTF.text?.count ?? 0>0 else {
            self.pincplErr.isHidden = false
            self.pricplTF.becomeFirstResponder()
            
            return
        }
        
        guard self.mblTF.text?.count ?? 0 == 10 else {
            self.mblErr.isHidden = false
            self.mblTF.becomeFirstResponder()
            
            return
        }
        
        guard self.adrssTF.text?.count ?? 0>0 else {
            self.adrssErr.isHidden = false
            self.adrssTF.becomeFirstResponder()
            
            return
        }
        
        guard self.distTF.text?.count ?? 0>0 else {
            self.distErr.isHidden = false
            self.distTF.becomeFirstResponder()
            
            return
        }
        
        guard self.mndlTF.text?.count ?? 0>0 else {
            self.mndlErr.isHidden = false
            self.mndlTF.becomeFirstResponder()
            
            return
        }
        
        guard self.pinTF.text?.count ?? 0==6 else {
            self.pinErr.isHidden = false
            self.pinTF.becomeFirstResponder()
            
            return
        }
        
        
        if self.pricplTF.text?.count ?? 0>0 && self.mblTF.text?.count ?? 0==10 && self.adrssTF.text?.count ?? 0>0 && self.distTF.text?.count ?? 0>0 && self.mndlTF.text?.count ?? 0>0 && self.pinTF.text?.count ?? 0==6 {
        
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
            
            let defaults = UserDefaults.standard
            let clgcde = "\(defaults.value(forKey: "COLLCODE") ?? "")"
            let clid = "\(defaults.value(forKey: "CLID") ?? "")"
            let pgid = "\(defaults.value(forKey: "ProgramID") ?? "")"
            let cid = "\(defaults.value(forKey: "CID") ?? "")"
            
            //create the url with URL
            let url = URL(string: adrssApi + "\(clid)&CID=\(cid)&ProgramID=\(pgid)&CollCode=\(clgcde)&cPrincipalName=\(self.pricplTF.text ?? "")&cMobileNo=\(self.mblTF.text ?? "")&Collegeaddress=\(self.adrssTF.text ?? "")&cDistrict=\(self.distTF.text ?? "")&cVillageMandal=\(self.mndlTF.text ?? "")&cPinCode=\(self.pinTF.text ?? "")".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)! //change the url

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
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSNumber
                    print("res:\(jsonResponse)")
                
                DispatchQueue.main.async {
                    
                if jsonResponse == 1 {
                    loadingView.hide()
                    //Loaf("Language Updated successfully.", state: .success, sender: self).show()

                    
                    defaults.set("1", forKey: "loginStatus")
                    
                        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                        self.navigationController?.isNavigationBarHidden = false
                        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                        self.navigationController?.pushViewController(vc, animated: true)
                
                                            
                }else if jsonResponse.value(forKey: "Message") as! String == "501" {
                    loadingView.hide()
                    //Loaf("Language Updated successfully.", state: .success, sender: self).show()

                        let alert = UIAlertController(title: "Alert", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                
                                            
                }else {
                    loadingView.hide()
                    //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                    
                    let alert = UIAlertController(title: "Alert", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                }
                } catch let error {
                    print(error.localizedDescription)
                    loadingView.hide()
                //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                                        
                let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                    
                }
            }
            })
            task.resume()
            
            
            
        
        }
    }
    
    @objc func resign(){
        self.pinTF.resignFirstResponder()
        self.pricplTF.resignFirstResponder()
        self.mblTF.resignFirstResponder()
        self.adrssTF.resignFirstResponder()
        self.distTF.resignFirstResponder()
        self.mndlTF.resignFirstResponder()
        
        if self.distTF.text?.count ?? 0>0 && self.mndlTF.text?.count ?? 0==0 {
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
        
            
            guard let gitUrl = URL(string: mandalApi + "\(self.distTF.tag)") else { return }
            
            print("url;\(gitUrl)")
                            
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
                                    
                    self.mndlData = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                    print("res:\(self.mndlData)")
                    
                    DispatchQueue.main.async {
                        
                        if self.mndlData?.count ?? 0>0 {
                        loadingView.hide()
                        self.mndlPicker.reloadAllComponents()
                                                        
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
    
}
