//
//  forgtPinVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 24/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class forgtPinVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var mblTF: UITextField!
    @IBOutlet weak var submitBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mblTF.layer.cornerRadius = 20.0
        self.mblTF.layer.borderWidth = 1.0
        self.mblTF.layer.masksToBounds = true;
        
        self.submitBttn.layer.cornerRadius = 20.0
        //self.submitBttn.layer.borderWidth = 1.0
        self.submitBttn.layer.masksToBounds = true;
        
        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.mblTF.inputAccessoryView = toolBar5
        
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
    
    @IBAction func submitAct(_ sender: UIButton) {
        if self.mblTF.text?.count == 10 {
          
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
           
        let myDevice : UIDevice = UIDevice.current
        let identifier : String = myDevice.identifierForVendor!.uuidString
        
            guard let gitUrl = URL(string: forgtApi + "\(self.mblTF.text!)&DEVICEID=\(identifier)") else { return }
                        
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
                                
                let jsonResponse = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSNumber
                    print("res:\(jsonResponse)")
                
                DispatchQueue.main.async {
                    
                if jsonResponse == 1 {
                    loadingView.hide()
                    //Loaf("Language Updated successfully.", state: .success, sender: self).show()

                    let alert = UIAlertController(title: "Success", message: "Successfully the PIN number sent to your registered mobile number.", preferredStyle: UIAlertController.Style.actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                        let vc:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                                            
                }else {
                    loadingView.hide()
                    //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                    
                    let alert = UIAlertController(title: "Alert", message: "Something went wrong.Try again.", preferredStyle: UIAlertController.Style.actionSheet)
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
        
            let alert = UIAlertController(title: "Alert", message: "Please enter valid registered mobile number..", preferredStyle: UIAlertController.Style.actionSheet)
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
