//
//  MenuViewController.swift
//  IOS_Chess
//
//  Created by rj morley on 4/14/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var WelcomeLabel: UILabel!
    
    @IBOutlet weak var PlayOutlet: UIButton!
    
    
    @IBAction func PlayButton(_ sender: Any) {
        performSegue(withIdentifier: "MenuToGame", sender: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        PlayOutlet.layer.cornerRadius = PlayOutlet.frame.height/2

        WelcomeLabel.layer.cornerRadius = WelcomeLabel.frame.height/2
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
