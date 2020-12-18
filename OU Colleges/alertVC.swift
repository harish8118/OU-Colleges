//
//  alertVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 01/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class alertVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var altTbl: UITableView!
    var AlrtData : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
        
        let dflts = UserDefaults.standard
        let clCde = dflts.value(forKey: "COLLCODE")
        
        guard let gitUrl = URL(string: alrtApi + "\(clCde ?? 1051)" ) else { return }
                        
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
                                
                self.AlrtData = try JSONSerialization.jsonObject(with:
                    data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                print("res:\(self.AlrtData)")
                
                DispatchQueue.main.async {
                    
                    if self.AlrtData?.count ?? 0>0 {
                    loadingView.hide()
                        
                    self.altTbl.reloadData()
                                                    
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
        
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.AlrtData?.count ?? 0>0 {
            return self.AlrtData?.count ?? 0
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "alrt", for: indexPath) as! clgCell
        
        rtrn.indxLbl.text = "\(indexPath.row+1)."
        
        let str = self.AlrtData?[indexPath.row] as! NSDictionary
        let str2 = str.value(forKey: "CREATEDDATE") as! String
        let tmp = str2.split(separator: "T")
        rtrn.dateLbl.text = String(tmp[0])
        
        rtrn.typLbl.text = "[\(str.value(forKey: "MSG_PRIORITY") ?? "LOW")]"
        rtrn.textLbl.text = "\(str.value(forKey: "MESSAGECONTENT") ?? " ")"
        rtrn.sbjctLbl.text = "- \(str.value(forKey: "MSG_SUBJECT") ?? " ")"
        
        return rtrn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc:alertVC2 = self.storyboard?.instantiateViewController(withIdentifier: "alertVC2") as! alertVC2
        vc.AlrtDict = self.AlrtData?[indexPath.row] as? NSDictionary
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
