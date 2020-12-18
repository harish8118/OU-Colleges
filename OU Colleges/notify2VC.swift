//
//  notify2VC.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 01/10/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit
import WebKit

class notify2VC: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var ntfyWebVW: WKWebView!
    var ntfyUrl : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url2 = URL(string: self.ntfyUrl ?? "")
        
        ntfyWebVW.load(URLRequest(url:url2!))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func homeAct(_ sender: UIBarButtonItem) {
        let vc:dashVC = self.storyboard?.instantiateViewController(withIdentifier: "dashVC") as! dashVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   

}
