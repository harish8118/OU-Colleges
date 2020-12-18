//
//  settingsVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 01/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import Loaf

class settingsVC: UIViewController, UITextFieldDelegate ,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settngTbl: UITableView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var oldMblTF: UITextField!
    @IBOutlet weak var newMblTF: UITextField!
    
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var oldPinTF: UITextField!
    @IBOutlet weak var newPinTF: UITextField!
    @IBOutlet weak var cnfrmPinTF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.oldPinTF.layer.cornerRadius = 20.0
        self.oldPinTF.layer.borderWidth = 1.0
        self.oldPinTF.layer.masksToBounds = true;
        
        self.newPinTF.layer.cornerRadius = 20.0
        self.newPinTF.layer.borderWidth = 1.0
        self.newPinTF.layer.masksToBounds = true;
        
        self.cnfrmPinTF.layer.cornerRadius = 20.0
        self.cnfrmPinTF.layer.borderWidth = 1.0
        self.cnfrmPinTF.layer.masksToBounds = true;
        
        self.oldMblTF.layer.cornerRadius = 20.0
        self.oldMblTF.layer.borderWidth = 1.0
        self.oldMblTF.layer.masksToBounds = true;
        
        self.newMblTF.layer.cornerRadius = 20.0
        self.newMblTF.layer.borderWidth = 1.0
        self.newMblTF.layer.masksToBounds = true;
        
        
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.newMblTF.inputAccessoryView = toolBar5
        self.cnfrmPinTF.inputAccessoryView = toolBar5
        self.oldMblTF.inputAccessoryView = toolBar5
        self.oldPinTF.inputAccessoryView = toolBar5
        self.newPinTF.inputAccessoryView = toolBar5
        

        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

          if textField==self.oldPinTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.oldPinTF.text?.count ?? 0<4) || string == "" {
                
                return true
            }else{
                return false
            }
            
        }else if textField==self.newPinTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.newPinTF.text?.count ?? 0<4) || string == "" {
                
                return true
            }else{
                return false
            }
            
        }else if textField==self.cnfrmPinTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.cnfrmPinTF.text?.count ?? 0<4) || string == "" {
                
                return true
            }else{
                return false
            }
            
        }else if textField==self.oldMblTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.oldMblTF.text?.count ?? 0<10) || string == "" {
                
                return true
            }else{
                return false
            }
            
        }else if textField==self.newMblTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.newMblTF.text?.count ?? 0<10) || string == "" {
                
                return true
            }else{
                return false
            }
            
        }

        
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 2
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "fclty", for: indexPath) as! clgCell
        var cl : UITableViewCell = UITableViewCell()
        if indexPath.row == 0 {
            let rtrn : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "stng", for: indexPath)
        
            cl = rtrn
        }else {
            let rtrn : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "stng2", for: indexPath)
            
            cl = rtrn
        }
        
        return cl
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.view1.isHidden = false
            self.view2.isHidden = true
            
            self.oldMblTF.text = ""
            self.newMblTF.text = ""
            
        }else if indexPath.row == 1 {
            self.view1.isHidden = false
            self.view2.isHidden = false
            
            self.oldPinTF.text = ""
            self.newPinTF.text = ""
            self.cnfrmPinTF.text = ""
            
        }
        
    }
    
    @IBAction func changeMblAct(_ sender: UIButton) {
        guard self.oldMblTF.text?.count == 10 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid 10 digit OLD Mobile number.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.newMblTF.text?.count == 10 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid 10 digit New Mobile number.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.newMblTF.text != self.oldMblTF.text else {
            let alert = UIAlertController(title: "Alert", message: "New Mobile number should not be same sa old mobile number..", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if self.oldMblTF.text?.count == 10 && self.newMblTF.text?.count == 10 {
          
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
            
        let dflts = UserDefaults.standard
        let myDevice : UIDevice = UIDevice.current
        let identifier : String = myDevice.identifierForVendor!.uuidString
            
        //create the url with URL
            let url = URL(string: chngMblApi + "\(self.oldMblTF.text ?? "73824")&DEVICEID=\(identifier)&NewMobile=\(self.newMblTF.text!)")! //change the url

        URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if let err = error {
            print("err:\(err)")
            let alert = UIAlertController(title: "Alert", message: "No internet is available. Please connect to network.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        guard let data = data else { return }
        do {
                            
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSNumber
            print("res:\(jsonResponse)")
            
            DispatchQueue.main.async {
                
                if jsonResponse == 1 {
                loadingView.hide()
                dflts.set(self.newMblTF.text, forKey: "Mobile")
                Loaf("Mobile number Updated successfully.", state: .success, sender: self).show()
                    
                self.view1.isHidden = true
                                                
            }else {
                loadingView.hide()
                //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                
                let alert = UIAlertController(title: "Failed", message: "Please enter valid old mobile number to update..", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
                
            }
                            
        } catch let err {
            print(err.localizedDescription)
                loadingView.hide()
            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
            
            }
        }.resume()
            
        }else {
        
            let alert = UIAlertController(title: "Alert", message: "Confirm Mobile number should be same as given Mobile number..", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.cnfrmPinTF.becomeFirstResponder()
        }))
            self.present(alert, animated: true, completion: nil)
        
        }
    }
    
    @IBAction func changePinAct(_ sender: UIButton) {
        guard self.oldPinTF.text?.count == 4 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid 4 digit OLD PIN number.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.newPinTF.text?.count == 4 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid 4 digit New PIN number.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.cnfrmPinTF.text?.count == 4 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid 4 digit Confirm PIN number.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.newPinTF.text != self.oldPinTF.text else {
            let alert = UIAlertController(title: "Alert", message: "New PIN number should not be same sa old PIN number..", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.newPinTF.text == self.cnfrmPinTF.text else {
            let alert = UIAlertController(title: "Alert", message: "New PIN number should  be same sa Confirm PIN number..", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if self.newPinTF.text?.count == 4 && self.cnfrmPinTF.text?.count == 4 && self.oldPinTF.text?.count == 4 {
          
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
            
        let dflts = UserDefaults.standard
            let mbl = dflts.value(forKey: "Mobile")
        let myDevice : UIDevice = UIDevice.current
        let identifier : String = myDevice.identifierForVendor!.uuidString
            
        //create the url with URL
            let url = URL(string: chngPinApi + "\(mbl ?? "73824")&DEVICEID=\(identifier)&PIN=\(self.oldPinTF.text ?? "1234")&NewPIN=\(self.newPinTF.text ?? "1234")")! //change the url
            print("url:\(url)")

        URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        if let err = error {
            print("err:\(err)")
            let alert = UIAlertController(title: "Alert", message: "No internet is available. Please connect to network.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
            
        guard let data = data else { return }
        do {
                            
            let jsonResponse = try JSONSerialization.jsonObject(with:
                data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSNumber
            print("res:\(jsonResponse)")
            
            DispatchQueue.main.async {
                
                if jsonResponse == 1 {
                loadingView.hide()
                dflts.set(self.newMblTF.text, forKey: "Mobile")
                Loaf("PIN number Updated successfully.", state: .success, sender: self).show()
                    
                self.view1.isHidden = true
                                                
            }else {
                loadingView.hide()
                //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                
                let alert = UIAlertController(title: "Failed", message: "Please enter valid old mobile number to update..", preferredStyle: UIAlertController.Style.actionSheet)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
                
            }
                            
        } catch let err {
            print(err.localizedDescription)
                loadingView.hide()
            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
            
            }
        }.resume()
            
        }else {
        
            let alert = UIAlertController(title: "Alert", message: "Confirm PIN number should be same as given PIN number..", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.cnfrmPinTF.becomeFirstResponder()
        }))
            self.present(alert, animated: true, completion: nil)
        
        }
        
    }
    
    @objc func resign() {
        self.oldMblTF.resignFirstResponder()
        self.newMblTF.resignFirstResponder()
        self.oldPinTF.resignFirstResponder()
        self.newPinTF.resignFirstResponder()
        self.cnfrmPinTF.resignFirstResponder()
        
    }
    

}
