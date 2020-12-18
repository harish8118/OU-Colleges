//
//  clgPrflVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 28/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class clgPrflVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var clgTbl: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    var clgData : NSDictionary?
    
    
    let dasArr = ["COLLEGE CODE :","COLLEGE NAME :","SOCIETY NAME :","PRINCIPAL NAME :","PHONE NO :","MOBILE NO :","SECRETARY NAME :","SECRETARY PHONE NO :","SECRETARY MOBILE NO :","ADDRESS :"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                        
                    self.clgTbl.reloadData()
                                                    
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
        
        if ROLEID == "3" {
            self.editButton.isEnabled = true
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.clgData?.count ?? 0>0 {
            return self.dasArr.count
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "clgInfo", for: indexPath) as! clgCell
        
        let str = "\(self.dasArr[indexPath.row])"
        //let dct = self.clgData?[0] as? NSDictionary
        
        rtrn.clgHdLbl.text = "\(str)"
        
        if indexPath.row == 0 {
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "CollCode") ?? "")"
            
        }else if indexPath.row == 1 {
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "CollName") ?? "")"
            
        }else if indexPath.row == 2 {
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "cSocietyName") ?? "")"
            
        }else if indexPath.row == 3 {
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "cPrincipalName") ?? "")"
            
        }else if indexPath.row == 4 {
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "cPhNo") ?? "")"
            
        }else if indexPath.row == 5 {
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "cMobileNo") ?? "")"
            
        }else if indexPath.row == 6 {
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "cSecretaryName") ?? "")"
            
        }else if indexPath.row == 7 {
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "cSecPhno") ?? "")"
            
        }else if indexPath.row == 8 {
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "cSecMobNo") ?? "")"
            
        }else if indexPath.row == 9 {
            
            rtrn.clgTtlLbl.text = "\(clgData?.value(forKey: "cStreet") ?? ""),\(self.clgData?.value(forKey: "cDistrict") ?? ""),\(self.clgData?.value(forKey: "cVillageMandal") ?? ""),\(self.clgData?.value(forKey: "cPinCode") ?? "")"
            
        }
        
        return rtrn
    }


    @IBAction func editPrflAct(_ sender: UIBarButtonItem) {
        let vc:addressVC = self.storyboard?.instantiateViewController(withIdentifier: "addressVC") as! addressVC
        vc.stat = 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
