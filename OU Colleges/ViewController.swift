//
//  ViewController.swift
//  OU Colleges
//
//  Created by Cyberheights Software Technologies Pvt Ltd on 24/09/20.
//  Copyright © 2020 Cyberheights Software Technologies Pvt Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginBttn: UIButton!
    @IBOutlet weak var signUpBttn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginBttn.layer.cornerRadius = 20.0
        //self.loginBttn.layer.borderWidth = 1.0
        self.loginBttn.layer.masksToBounds = true;
        
        self.signUpBttn.layer.cornerRadius = 20.0
        //self.signUpBttn.layer.borderWidth = 1.0
        self.signUpBttn.layer.masksToBounds = true;
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
    }

    @IBAction func loginAction(_ sender: UIButton) {
        let vc:loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! loginVC
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func signUpAction(_ sender: UIButton) {
        let vc:sigmnUpVC = self.storyboard?.instantiateViewController(withIdentifier: "sigmnUpVC") as! sigmnUpVC
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    
}

