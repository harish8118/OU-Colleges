//
//  stdntDtlVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 08/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class stdntDtlVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var htTF: UITextField!
    @IBOutlet weak var goBttn: UIButton!
    @IBOutlet weak var infoTbl: UITableView!
    
    var infoData : NSDictionary?
    
    let dasArr = ["Father Name :","Mother Name :","Gender :","Course :","Coursse Name :","Second Language :","Category :","Sub-Category :","Spl-Category :","Blood Group :","Doj :","Medium :","Email ID :","Mobile No :","Identification Marks :","Address :"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.htTF.layer.cornerRadius = 15.0
        self.htTF.layer.borderWidth = 1.0
        self.htTF.layer.masksToBounds = true;

        let toolBar5 : UIToolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        toolBar5.tintColor = UIColor.black
        let done1 : UIBarButtonItem = UIBarButtonItem.init(title: "SELECT", style: UIBarButtonItem.Style.done, target: self, action: #selector(resign))
        let space1 : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar5.setItems(NSArray(objects: space1,done1) as? [UIBarButtonItem], animated: true)
        self.htTF.inputAccessoryView = toolBar5
        
        
        
        if self.infoData?.count ?? 0>0 {
            self.htTF.isHidden = true
            self.goBttn.isHidden = true
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let acceptedInput:NSCharacterSet = NSCharacterSet.init(charactersIn: "0123456789")

          if textField==self.htTF {
            if (string.components(separatedBy: acceptedInput as CharacterSet).count > 1 && self.htTF.text?.count ?? 0<12) || string == "" {
                
                return true
            }else{
                return false
            }
        }

        
        return true
    }
    
    @IBAction func goAct(_ sender: UIButton) {
        guard self.htTF.text?.count == 12 else {
            let alert = UIAlertController(title: "Alert", message: "Please enter valid 12 digit HallTicket number.", preferredStyle: UIAlertController.Style.actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        if self.htTF.text?.count == 12 {
            
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
           
        let dflts = UserDefaults.standard
        let clCde = dflts.value(forKey: "COLLCODE")
        
        guard let gitUrl = URL(string: stdntInfoApi + "\(self.htTF.text!)&Collcode=\(clCde ?? 1051)") else { return }
                        
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
                                
                self.infoData = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                print("res:\(self.infoData)")
                
                DispatchQueue.main.async {
                    
                    if self.infoData?.count ?? 0>0 {
                    loadingView.hide()
                        self.htTF.resignFirstResponder()
                        self.infoTbl.reloadData()
                                                    
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.infoData?.count ?? 0>0 {
        
            return 17
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cl : UITableViewCell = UITableViewCell()
        
        if indexPath.row==0 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! clgCell
            
            let url = URL(string: infoData?.value(forKey: "Photo") as! String)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            
            rtrn.prflImg.image = UIImage(data: data!)
            rtrn.nameLbl.text = "\(infoData?.value(forKey: "SName") ?? "")"
            rtrn.mblLbl.text = "\(infoData?.value(forKey: "HTNo") ?? "")"
            
            cl = rtrn
        }else if indexPath.row == 1 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "FName") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 2 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "Mname") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 3 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "SGender") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 4 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "Course") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 5 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "CourseName") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 6 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "SecondLanguage") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 7 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "Category") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 8 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "SubCategory") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 9 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "SplCat") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 10 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "BGroup") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 11 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "DOJ") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 12 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "Medium") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 13 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "EmailId") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 14 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ": \(infoData?.value(forKey: "SCPhone") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 15 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ":1. \(infoData?.value(forKey: "Identification1") ?? "") \n 2.\(infoData?.value(forKey: "Identification2") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }else if indexPath.row == 16 {
            let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! clgCell
            
            rtrn.clgTtlLbl.text = ":\(infoData?.value(forKey: "SCAddress1") ?? ""),\(infoData?.value(forKey: "SCAddress2") ?? ""),\(infoData?.value(forKey: "SCAddress3") ?? ""),\(infoData?.value(forKey: "SCAddress4") ?? ""),\(infoData?.value(forKey: "SCPin") ?? "")"
            rtrn.clgHdLbl.text = "\(dasArr[indexPath.row-1])"
            
            cl = rtrn
            
        }
        
        
        return cl
    }
    
    @IBAction func homeAct(_ sender: UIBarButtonItem) {
        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func resign() {
        self.htTF.resignFirstResponder()
    }

}
