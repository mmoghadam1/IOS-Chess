//
//  LogInViewController.swift
//  IOS_Chess
//
//  Created by rj morley on 4/7/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var UsernameTF: UITextField!
    
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var SignInOutlet: UIButton!
    
    
    @IBAction func LogInButton(_ sender: Any) {
        guard let Username = UsernameTF.text, let password = PasswordTF.text else {return}
        Firebase.Auth.auth().signIn(withEmail: Username, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else if let user = Firebase.Auth.auth().currentUser{
                print("logged in")
                self.performSegue(withIdentifier: "SignInToHome", sender: self)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        PasswordTF.isSecureTextEntry = true
        SignInOutlet.layer.cornerRadius = SignInOutlet.frame.height/3
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
