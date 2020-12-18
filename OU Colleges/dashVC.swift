//
//  dashVC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 26/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import Loaf

class dashVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var dashTbl: UICollectionView!
    @IBOutlet weak var rolTxt: UILabel!
    
    let dasArr = ["COLLEGE PROFILE","NOTIFICATIONS","ALERTS","FACULTY","STUDENTS","COLLEGE ANALYTICS","SETTINGS","LOGOUT"]
    
    let dashImgArr = ["college-profile","notifications","alerts","faculty","students","analytics","settings","logout-dash"]
    
    let clgAdminArr = ["CREATE USER","COLLEGE PROFILE","NOTIFICATIONS","ALERTS","FACULTY","STUDENTS","COLLEGE ANALYTICS","SETTINGS","LOGOUT"]
    
    let clgAdmnImgArr = ["create-user","college-profile","notifications","alerts","faculty","students","analytics","settings","logout-dash"]
    
    let unvUsrArr = ["CREATE USER","NOTIFICATIONS","POST ALERTS","SETTINGS","LOGOUT"]
    
    let unvUsrImgArr = ["create-user","notifications","alerts","settings","logout-dash"]
    
    let unvAdmnArr = ["CREATE USER","NOTIFICATIONS","POST ALERTS","SETTINGS","LOGOUT"]
    
    let unvAdmnImgArr = ["create-user","notifications","alerts","settings","logout-dash"]
    
    var rllId : String!
    var unRead : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated:true);
        self.navigationController?.navigationBar.isHidden = false
        
        self.unRead = "0"
        let dflts = UserDefaults.standard
        rllId = "\(dflts.value(forKey: "ROLEID") ?? "")"
        let clgID = "\(dflts.value(forKey: "COLLCODE") ?? "")"
        
        if rllId == "3" || rllId == "4" {
            
            loadingView.shouldTapToDismiss = false
            loadingView.show(on: view)
            
            guard let gitUrl = URL(string: alrtCuntApi + "\(clgID)" ) else { return }
                            
                URLSession.shared.dataTask(with: gitUrl) { (data, response, error) in
                
                if let err = error {
                    print("err:\(err)")
                    Loaf("No internet is available. Please connect to network.", state: .error, sender: self).show()
                    
                }
                    
                guard let data = data else { return }
                do {
                                    
                    let readDict = try JSONSerialization.jsonObject(with:
                        data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                    print("res:\(readDict)")
                    
                    DispatchQueue.main.async {
                        
                        if readDict?.value(forKey: "UNREADMESSAGES") as? NSNumber == 0 {
                        loadingView.hide()
  
                                                        
                    }else {
                        loadingView.hide()
                        
                        self.unRead = "\(readDict?.value(forKey: "UNREADMESSAGES") ?? "")"
                        self.dashTbl.reloadData()
                        //Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                    }
                        
                    }
                                    
                } catch let err {
                    print(err.localizedDescription)
                        loadingView.hide()
                    Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                    }
                }.resume()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if rllId == "1" {
            self.rolTxt.isHidden = false
            self.rolTxt.text = " University Admin"
            return unvAdmnArr.count
            
        }else if rllId == "2" {
            self.rolTxt.isHidden = false
            self.rolTxt.text = " University User"
            return unvUsrArr.count
            
        }else if rllId == "3" {
            self.rolTxt.isHidden = false
            self.rolTxt.text = " College Admin"
            return clgAdminArr.count
            
        }else if rllId == "4" {
            self.rolTxt.isHidden = true
            return dasArr.count
            
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cl : UICollectionViewCell = UICollectionViewCell()
        
        let rtrn : dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash", for: indexPath) as! dashCell
        
        if rllId == "1" {
            rtrn.dashImg.image = UIImage.init(named: unvAdmnImgArr[indexPath.row])
            rtrn.dashLbl.text =  unvAdmnArr[indexPath.row]
            
            cl = rtrn
            
        }else if rllId == "2" {
            rtrn.dashImg.image = UIImage.init(named: unvUsrImgArr[indexPath.row])
            rtrn.dashLbl.text =  unvUsrArr [indexPath.row]
            
            cl = rtrn
            
        }else if rllId == "3" {
            rtrn.dashImg.image = UIImage.init(named: clgAdmnImgArr[indexPath.row])
            rtrn.dashLbl.text =  clgAdminArr[indexPath.row]
            if indexPath.row == 2 && unRead != "0" {
                let vc : dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash2", for: indexPath) as! dashCell
                
                vc.cuntLbl.text = "\(unRead ?? "")"
                vc.cellBackVW.layer.cornerRadius = vc.cellBackVW.frame.size.height/2
                vc.cellBackVW.layer.masksToBounds = true
                
                vc.layer.cornerRadius = 15.0
                vc.layer.masksToBounds = true;
                
                return cl
                
            }
            
            cl = rtrn
            
        }else if rllId == "4" {
            rtrn.dashImg.image = UIImage.init(named: dashImgArr[indexPath.row])
            rtrn.dashLbl.text = dasArr[indexPath.row]
            if indexPath.row == 3 && unRead != "0" {
                let vc : dashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "dash2", for: indexPath) as! dashCell
                
                vc.cuntLbl.text = "\(unRead ?? "")"
                vc.cellBackVW.layer.cornerRadius = vc.cellBackVW.frame.size.height/2
                vc.cellBackVW.layer.masksToBounds = true
                
                vc.layer.cornerRadius = 15.0
                vc.layer.masksToBounds = true;
                
                return vc
                
            }
        }
        
        rtrn.cellBackVW.layer.cornerRadius = rtrn.cellBackVW.frame.size.height/2
        rtrn.cellBackVW.layer.masksToBounds = true
        
        rtrn.layer.cornerRadius = 20.0
        rtrn.layer.borderColor = UIColor.orange.cgColor
        rtrn.layer.masksToBounds = true;
        
        cl = rtrn
        return cl
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
    
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if rllId == "1" {
            if indexPath.row == 0 {

                let alert = UIAlertController(title: "CREATE USER", message: "Please fill all the fileds to create. ", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter Mobile Number"
                    textField.keyboardType = .numberPad
                }
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter User Name"
                    textField.keyboardType = .default
                }

                alert.addAction(UIAlertAction(title: "CREATE", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                    let textField2 = alert?.textFields![1]
                    
                    print("Text field: \(textField?.text ?? "")-\(textField2?.text ?? "")")
                    
                    loadingView.shouldTapToDismiss = false
                    loadingView.show(on: self.view)

                    let url = URL(string: unvUsrApi + "\(textField?.text ?? "")&Name=\(textField2?.text ?? "")")! //change the url

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
                            Loaf("University User created successfully.", state: .success, sender: self).show()
                          
                        }else {
                            loadingView.hide()
                            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
   
                        }
                        }
                        } catch let error {
                            print(error.localizedDescription)
                            loadingView.hide()
                            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                            
                        }
                    }
                    })
                    task.resume()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)
                
            }else if indexPath.row == 1 {

                let vc:notifyVC = self.storyboard?.instantiateViewController(withIdentifier: "notifyVC") as! notifyVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 2 {
                let vc:postAlrtVC = self.storyboard?.instantiateViewController(withIdentifier: "postAlrtVC") as! postAlrtVC
                self.navigationController?.pushViewController(vc, animated: true)
                
                
            }else  if indexPath.row == 3 {

                let vc:settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! settingsVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else  if indexPath.row == 4 {
                let defaults = UserDefaults.standard
                defaults.set("0", forKey: "loginStatus")
                
                let vc:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if rllId == "2" {
            if indexPath.row == 0 {
                
                let alert = UIAlertController(title: "CREATE USER", message: "Please fill all the fileds to create. ", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter Mobile Number"
                    textField.keyboardType = .numberPad
                }
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter User Name"
                    textField.keyboardType = .default
                }
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter College Code"
                    textField.keyboardType = .numberPad
                }

                alert.addAction(UIAlertAction(title: "CREATE", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                    let textField2 = alert?.textFields![1]
                    let textField3 = alert?.textFields![2]
                    
                    print("Text field: \(textField?.text ?? "")-\(textField2?.text ?? "")-\(textField3?.text ?? "")")
                    
                    loadingView.shouldTapToDismiss = false
                    loadingView.show(on: self.view)

                    let url = URL(string: clgAdmnApi + "\(textField?.text ?? "")&Collcode=\(textField3?.text ?? "")&Name=\(textField2?.text ?? "")")! //change the url

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
                            Loaf("College Admin created successfully.", state: .success, sender: self).show()
                        
                        }else {
                            loadingView.hide()
                            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                
                        }
                        }
                        } catch let error {
                            print(error.localizedDescription)
                            loadingView.hide()
                            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                            
                        }
                    }
                    })
                    task.resume()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)
                
            }else if indexPath.row == 1 {

                let vc:notifyVC = self.storyboard?.instantiateViewController(withIdentifier: "notifyVC") as! notifyVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 2 {

                let vc:postAlrtVC = self.storyboard?.instantiateViewController(withIdentifier: "postAlrtVC") as! postAlrtVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else  if indexPath.row == 3 {

                let vc:settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! settingsVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else  if indexPath.row == 4 {
                let defaults = UserDefaults.standard
                defaults.set("0", forKey: "loginStatus")
                
                let vc:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if rllId == "3" {
            if indexPath.row == 0 {
                
                let alert = UIAlertController(title: "CREATE USER", message: "Please fill all the fileds to create. ", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter Mobile Number"
                    textField.keyboardType = .numberPad
                }
                
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter User Name"
                    textField.keyboardType = .default
                }
                
                alert.addTextField { (textField) in
                    textField.placeholder = "Enter College Code"
                    textField.keyboardType = .numberPad
                }

                alert.addAction(UIAlertAction(title: "CREATE", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                    let textField2 = alert?.textFields![1]
                    let textField3 = alert?.textFields![2]
                    
                    print("Text field: \(textField?.text ?? "")-\(textField2?.text ?? "")-\(textField3?.text ?? "")")
                    
                    loadingView.shouldTapToDismiss = false
                    loadingView.show(on: self.view)

                    let url = URL(string: clgUsrApi + "\(textField?.text ?? "")&Collcode=\(textField3?.text ?? "")&Name=\(textField2?.text ?? "")")! //change the url
                    print("url:\(url)")

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
                            Loaf("College User created successfully.", state: .success, sender: self).show()
                        
                        }else {
                            loadingView.hide()
                            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                
                        }
                        }
                        } catch let error {
                            print(error.localizedDescription)
                            loadingView.hide()
                            Loaf("Something went wrong.Try again.", state: .error, sender: self).show()
                            
                        }
                    }
                    })
                    task.resume()
                }))
                
                alert.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)
            }else if indexPath.row == 1 {

                let vc:clgPrflVC = self.storyboard?.instantiateViewController(withIdentifier: "clgPrflVC") as! clgPrflVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 2 {

                let vc:notifyVC = self.storyboard?.instantiateViewController(withIdentifier: "notifyVC") as! notifyVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 3 {

                let vc:alertVC = self.storyboard?.instantiateViewController(withIdentifier: "alertVC") as! alertVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 4 {

                let vc:facultyVC = self.storyboard?.instantiateViewController(withIdentifier: "facultyVC") as! facultyVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else if indexPath.row == 5 {

                let vc:stdntVC = self.storyboard?.instantiateViewController(withIdentifier: "stdntVC") as! stdntVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else  if indexPath.row == 6 {

                let vc:clgPrflVC = self.storyboard?.instantiateViewController(withIdentifier: "clgPrflVC") as! clgPrflVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else  if indexPath.row == 7 {

                let vc:settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! settingsVC
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else  if indexPath.row == 8 {
                let defaults = UserDefaults.standard
                defaults.set("0", forKey: "loginStatus")
                
                let vc:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else if rllId == "4" {
          
        if indexPath.row == 0 {

            let vc:clgPrflVC = self.storyboard?.instantiateViewController(withIdentifier: "clgPrflVC") as! clgPrflVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 1 {

            let vc:notifyVC = self.storyboard?.instantiateViewController(withIdentifier: "notifyVC") as! notifyVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 2 {

            let vc:alertVC = self.storyboard?.instantiateViewController(withIdentifier: "alertVC") as! alertVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 3 {

            let vc:facultyVC = self.storyboard?.instantiateViewController(withIdentifier: "facultyVC") as! facultyVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 4 {

            let vc:stdntVC = self.storyboard?.instantiateViewController(withIdentifier: "stdntVC") as! stdntVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else  if indexPath.row == 5 {

            let vc:clgPrflVC = self.storyboard?.instantiateViewController(withIdentifier: "clgPrflVC") as! clgPrflVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else  if indexPath.row == 6 {

            let vc:settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "settingsVC") as! settingsVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else  if indexPath.row == 7 {
            let defaults = UserDefaults.standard
            defaults.set("0", forKey: "loginStatus")
            
            let vc:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
        }
    
    }

    @IBAction func homeAct(_ sender: UIBarButtonItem) {
        let defaults = UserDefaults.standard
        defaults.set("0", forKey: "loginStatus")
        
        let vc:ViewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

}
