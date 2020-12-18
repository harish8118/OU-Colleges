//
//  alertVC2.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 01/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class alertVC2: UIViewController {

    @IBOutlet weak var dtLbl: UILabel!
    @IBOutlet weak var typLbl: UILabel!
    @IBOutlet weak var sbjctLbl: UILabel!
    @IBOutlet weak var contntLbl: UITextView!
    
    var AlrtDict : NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.shouldTapToDismiss = false
        loadingView.show(on: view)
        
        let str2 = self.AlrtDict.value(forKey: "CREATEDDATE") as! String
        let tmp = str2.split(separator: "T")
        self.dtLbl.text = String(tmp[0])
        
        self.contntLbl.text = self.AlrtDict.value(forKey: "MESSAGECONTENT") as? String
        self.sbjctLbl.text = "- \(self.AlrtDict.value(forKey: "MSG_SUBJECT") ?? " " )" 
        self.typLbl.text = "[\(self.AlrtDict.value(forKey: "MSG_PRIORITY") ?? " ")]"

        loadingView.hide()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func homeAct(_ sender: UIBarButtonItem) {
        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    

}
