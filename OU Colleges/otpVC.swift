//
//  otpVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 24/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class otpVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var submitBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.otpTF.layer.cornerRadius = 20.0
        self.otpTF.layer.borderWidth = 1.0
        self.otpTF.layer.masksToBounds = true;
        
        self.submitBttn.layer.cornerRadius = 20.0
        //self.submitBttn.layer.borderWidth = 1.0
        self.submitBttn.layer.masksToBounds = true;
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.otpTF.inputAccessoryView = toolBar5
        
        // Do any additional setup after loading the view.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

          if textField==self.otpTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.otpTF.text?.count ?? 0<6) || string == "" {
                
                return true
            }else{
                return false
            }
        }

        
        return true
    }
    
    @IBAction func submitAct(_ sender: UIButton) {
        if self.otpTF.text?.count == 6 {
          
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
            
        let dflts = UserDefaults.standard
        let  mbl = dflts.value(forKey: "Mobile")
            
        //create the url with URL
        let url = URL(string: otpApi + "\(mbl ?? "73824")&OTP=\(self.otpTF.text!)")! //change the url

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

                let vc:setPinVC = self.storyboard?.instantiateViewController(withIdentifier: "setPinVC") as! setPinVC
                self.navigationController?.isNavigationBarHidden = false
                self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
                self.navigationController?.pushViewController(vc, animated: true)
            
                                        
            }else {
                loadingView.hide()
                //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                
                let alert = UIAlertController(title: "Alert", message: "Please enter valid 6 digit OTP number.", preferredStyle: UIAlertController.Style.actionSheet)
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
        
            let alert = UIAlertController(title: "Alert", message: "Please enter valid 6 digit OTP..", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            self.otpTF.becomeFirstResponder()
        }))
            self.present(alert, animated: true, completion: nil)
        
        }
        
        
    }
    
    @objc func resign(){
        self.otpTF.resignFirstResponder()
        
    }

}
