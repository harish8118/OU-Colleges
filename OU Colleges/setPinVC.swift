//
//  setPinVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 24/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class setPinVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var cnfrmPinTF: UITextField!
    @IBOutlet weak var setBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pinTF.layer.cornerRadius = 20.0
        self.pinTF.layer.borderWidth = 1.0
        self.pinTF.layer.masksToBounds = true;
        
        self.cnfrmPinTF.layer.cornerRadius = 20.0
        self.cnfrmPinTF.layer.borderWidth = 1.0
        self.cnfrmPinTF.layer.masksToBounds = true;
        
        self.setBttn.layer.cornerRadius = 20.0
        //self.setBttn.layer.borderWidth = 1.0
        self.setBttn.layer.masksToBounds = true;
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.pinTF.inputAccessoryView = toolBar5
        self.cnfrmPinTF.inputAccessoryView = toolBar5
        
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

          if textField==self.pinTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.pinTF.text?.count ?? 0<4) || string == "" {
                
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
        }

        
        return true
    }
    
    @IBAction func setAct(_ sender: UIButton) {
        guard self.pinTF.text?.count == 4 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid 4 digit PIN number.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.cnfrmPinTF.text?.count == 4 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid 4 digit confirm PIN number.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if self.pinTF.text?.count == 4 && self.pinTF.text == self.cnfrmPinTF.text {
          
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
            
        let dflts = UserDefaults.standard
        let  mbl = dflts.value(forKey: "Mobile")
        let myDevice : UIDevice = UIDevice.current
        let identifier : String = myDevice.identifierForVendor!.uuidString
            
        //create the url with URL
        let url = URL(string: pinApi + "\(mbl ?? "73824")&PIN=\(self.pinTF.text!)&DEVICEID=\(identifier)")! //change the url

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
                dflts.set("1", forKey: "loginStatus")
                
                let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                self.navigationController?.pushViewController(vc, animated: true)
            
                                        
            }else {
                loadingView.hide()
                //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                
                let alert = UIAlertController(title: "Alert", message: "Something went wrong please try again later.", preferredStyle: UIAlertController.Style.actionSheet)
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
        
        }else {
        
            let alert = UIAlertController(title: "Alert", message: "Confirm PIN number should be same as given PIN number..", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.cnfrmPinTF.becomeFirstResponder()
        }))
            self.present(alert, animated: true, completion: nil)
        
        }
        
        
        
    }
    
    @objc func resign(){
        self.pinTF.resignFirstResponder()
        self.cnfrmPinTF.resignFirstResponder()
    }

}
