//
//  signUpViewController.swift
//  IOS_Chess
//
//  Created by rj morley on 4/7/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit

import Firebase

class signUpViewController: UIViewController {

    @IBOutlet weak var EmailTF: UITextField!
    
    @IBOutlet weak var PasswordTF: UITextField!
    
    @IBOutlet weak var signUPOutlet: UIButton!
    
    @IBOutlet weak var LogInOutlet: UIButton!
    
    @IBAction func CreateAccount(_ sender: Any) {
        let email = EmailTF.text
        let password = PasswordTF.text
        let ref = Database.database().reference().root
        
        if EmailTF.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
        if PasswordTF.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your Password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        else {
            Firebase.Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    print("new user created")
                    let user = Firebase.Auth.auth().currentUser
                    ref.child("users").child((user?.uid)!).child("wins").setValue(0)
                    
                    self.performSegue(withIdentifier: "CreateAccountToHome", sender: self)
                }
            })
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUPOutlet.layer.cornerRadius = signUPOutlet.frame.height/3
        LogInOutlet.layer.cornerRadius = LogInOutlet.frame.height/3
        
        
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}
