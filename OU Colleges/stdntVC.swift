//
//  stdntVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 06/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class stdntVC: UIViewController ,UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var stdnTbl: UITableView!
    @IBOutlet weak var StdnCltnVW: UICollectionView!
    @IBOutlet weak var stdntTlLbl: UILabel!
    
    var stdntCuntArr : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 2
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let rtrn : clgCell = tableView.dequeueReusableCell(withIdentifier: "fclty", for: indexPath) as! clgCell
        var cl : UITableViewCell = UITableViewCell()
        if indexPath.row == 0 {
            let rtrn : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "stdnt", for: indexPath)
        
            cl = rtrn
        }else {
            let rtrn : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "stdnt2", for: indexPath)
            
            cl = rtrn
        }
        
        return cl
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            self.StdnCltnVW.isHidden = false
            
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
            
            let dflts = UserDefaults.standard
            let clCde = dflts.value(forKey: "COLLCODE")
            
            guard let gitUrl = URL(string: stdntCuntApi + "\(clCde ?? 1051)" ) else { return }
                            
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
                                    
                    self.stdntCuntArr = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray
                    print("res:\(self.stdntCuntArr)")
                    
                    DispatchQueue.main.async {
                        
                        if self.stdntCuntArr?.count ?? 0>0 {
                        loadingView.hide()
                            self.stdntTlLbl.isHidden = false
                        self.StdnCltnVW.reloadData()
                                                        
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
            
        }else if indexPath.row == 1 {
            self.StdnCltnVW.isHidden = true
            let vc:stdntDtlVC = self.storyboard?.instantiateViewController(withIdentifier: "stdntDtlVC") as! stdntDtlVC
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        }
        
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if stdntCuntArr?.count ?? 0>0 {
            return stdntCuntArr?.count ?? 0
            
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rtrn : dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "pgrmStdnt", for: indexPath) as! dashCell
        
        let str = self.stdntCuntArr?[indexPath.row] as! NSDictionary
        
        rtrn.stdnCount.text = "\(str.value(forKey: "TOTALSTUDENTS") ?? 0)"
        rtrn.pgrmLbl.text = str.value(forKey: "PROGRAM") as? String
        

        rtrn.layer.cornerRadius = 15.0
        rtrn.layer.borderColor = UIColor.blue.cgColor
        rtrn.layer.borderWidth = 1.0
        rtrn.layer.masksToBounds = true;
        
        return rtrn
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc:stdntInfoVC = self.storyboard?.instantiateViewController(withIdentifier: "stdntInfoVC") as! stdntInfoVC
        let str = self.stdntCuntArr?[indexPath.row] as! NSDictionary
        vc.pgrm = "\(str.value(forKey: "PROGRAMID") ?? 0)"
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
