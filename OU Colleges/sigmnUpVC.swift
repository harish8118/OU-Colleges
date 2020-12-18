//
//  sigmnUpVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 24/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class sigmnUpVC: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var mblTF: UITextField!
    @IBOutlet weak var signinBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mblTF.layer.cornerRadius = 20.0
        self.mblTF.layer.borderWidth = 1.0
        self.mblTF.layer.masksToBounds = true;
        
        self.signinBttn.layer.cornerRadius = 20.0
        //self.signinBttn.layer.borderWidth = 1.0
        self.signinBttn.layer.masksToBounds = true;
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.mblTF.inputAccessoryView = toolBar5
        
        
        self.navigationController?.navigationBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

          if textField==self.mblTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.mblTF.text?.count ?? 0<10) || string == "" {
                
                return true
            }else{
                return false
            }
        }

        
        return true
    }
    
    @IBAction func signinAct(_ sender: UIButton) {
      if self.mblTF.text?.count == 10 {
          
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
            
        //create the url with URL
        let url = URL(string: regstrApi + "\(self.mblTF.text!)")! //change the url

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
                
            if jsonResponse.value(forKey: "STATUS") as? NSNumber == 1 {
                loadingView.hide()
                //Loaf("Language Updated successfully.", state: .success, sender: self).show()

                let defaults = UserDefaults.standard
                defaults.set(self.mblTF.text!, forKey: "Mobile")
                defaults.set(jsonResponse.value(forKey: "CLID"), forKey: "CLID")
                defaults.set(jsonResponse.value(forKey: "COLLCODE"), forKey: "COLLCODE")
                defaults.set(jsonResponse.value(forKey: "ROLEID"), forKey: "ROLEID")
                defaults.set(jsonResponse.value(forKey: "USERNAME"), forKey: "USERNAME")
                
                let vc:otpVC = self.storyboard?.instantiateViewController(withIdentifier: "otpVC") as! otpVC
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                self.navigationController?.pushViewController(vc, animated: true)
            
                                        
            }else if jsonResponse.value(forKey: "Message") as! String == "501" {
                loadingView.hide()
                //Loaf("Language Updated successfully.", state: .success, sender: self).show()

                    let alert = UIAlertController(title: "Alert", message: "The given number not found with us.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
            
                                        
            }else {
                loadingView.hide()
                //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                
                let alert = UIAlertController(title: "Alert", message: "The given number not registered with us.", preferredStyle: UIAlertController.Style.actionSheet)
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
        
            let alert = UIAlertController(title: "Alert", message: "Please enter your valid registered Mobile number..", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.mblTF.becomeFirstResponder()
        }))
            self.present(alert, animated: true, completion: nil)
        
        }
        
        
        
    }
    
    @objc func resign(){
        self.mblTF.resignFirstResponder()
        
    }

}
