//
//  loginVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 24/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class loginVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var pinTF: UITextField!
    @IBOutlet weak var loginBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pinTF.layer.cornerRadius = 20.0
        self.pinTF.layer.borderWidth = 1.0
        self.pinTF.layer.masksToBounds = true;
        
        self.loginBttn.layer.cornerRadius = 20.0
        //self.loginBttn.layer.borderWidth = 1.0
        self.loginBttn.layer.masksToBounds = true;
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.pinTF.inputAccessoryView = toolBar5
        
        
        self.navigationController?.navigationBar.isHidden = false
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
        }

        
        return true
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
    if self.pinTF.text?.count ==  4 {
            
        let myDevice : UIDevice = UIDevice.current
        let identifier : String = myDevice.identifierForVendor!.uuidString
        
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
        
        //create the url with URL
        let url = URL(string: loginApi + "\(self.pinTF.text!)&DEVICEID=\(identifier)")! //change the url

        print("url:\(url)")
         //create the session object
         let session = URLSession.shared

         //now create the URLRequest object using the url object
         var request = URLRequest(url: url)
         request.httpMethod = "POST" //set http method as POST

//         do {
//             request.httpBody = try JSONSerialization.data(withJSONObject: nilp, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//         } catch let error {
//             print(error.localizedDescription)
//
//           // Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
//
//            let alert = UIAlertController(title: "Failed", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }

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
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                print("res:\(jsonResponse)")
               
               DispatchQueue.main.async {
                   
                if jsonResponse?.value(forKey: "STATUS") as? NSNumber == 3 {
 
                let defaults = UserDefaults.standard
                
                defaults.set(jsonResponse?.value(forKey: "MOBILE"), forKey: "Mobile")
                defaults.set(jsonResponse?.value(forKey: "CLID"), forKey: "CLID")
                defaults.set(jsonResponse?.value(forKey: "COLLCODE"), forKey: "COLLCODE")
                defaults.set(jsonResponse?.value(forKey: "ROLEID"), forKey: "ROLEID")
                defaults.set(jsonResponse?.value(forKey: "USERNAME"), forKey: "USERNAME")
                defaults.set(jsonResponse?.value(forKey: "ProgramID"), forKey: "ProgramID")
                defaults.set("\(jsonResponse?.value(forKey: "ADDRESSSTATUSID") ?? "0")", forKey: "ADDRESSSTATUSID")
                
                    self.callCIDAct()
                                        
               }else {
                //SKActivityIndicator.dismiss()
                //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                loadingView.hide()
                
                let alert = UIAlertController(title: "Failed", message: "The entered PIN number not registered with us.", preferredStyle: UIAlertController.Style.actionSheet)
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
            let alert = UIAlertController(title: "Alert", message: "Please enter your registered PIN number..", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.pinTF.becomeFirstResponder()
        }))
            self.present(alert, animated: true, completion: nil)
        
        }
        
        
        
    }
    
    func callCIDAct() {
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
            
        let dflts = UserDefaults.standard
        let  clgCde = dflts.value(forKey: "COLLCODE")
        let  pgcde = dflts.value(forKey: "ProgramID")
            
        //create the url with URL
        let url = URL(string: cidApi + "\(clgCde ?? "73824")&ProgramID=\(pgcde ?? "")")! //change the url

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
                
                if jsonResponse.count>0 {
                //Loaf("Language Updated successfully.", state: .success, sender: self).show()
                
                dflts.set(jsonResponse.value(forKey: "CID"), forKey: "CID")
                
                    if dflts.value(forKey: "ROLEID") as? NSNumber  == 3 &&  "\(dflts.value(forKey: "ADDRESSSTATUSID") ?? "" )" == "" {
                        loadingView.hide()
                        
                        let vc:addressVC = self.storyboard?.instantiateViewController(withIdentifier: "addressVC") as! addressVC
                        vc.stat = 0
                        self.navigationController?.isNavigationBarHidden = false
                        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        print("adrs err")
                        return}
                    
                    //print("adrs :\(adrsss)")
                    dflts.set("1", forKey: "loginStatus")
                    
                    loadingView.hide()
                    
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
        
    }
    
    @IBAction func forgotAct(_ sender: UIButton) {
        let vc:forgtPinVC = self.storyboard?.instantiateViewController(withIdentifier: "forgtPinVC") as! forgtPinVC
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func resign(){
        self.pinTF.resignFirstResponder()
        
    }
    
}
