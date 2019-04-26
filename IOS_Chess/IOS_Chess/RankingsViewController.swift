//
//  RankingsViewController.swift
//  IOS_Chess
//
//  Created by rj morley on 4/25/19.
//  Copyright © 2019 ___rickjames___. All rights reserved.
//

import UIKit
import Firebase

class RankingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var leaderboard = [String: Int]()
    var rankedLeaderboard = [String: Int]()
    @IBOutlet weak var LeaderBoardTable: UITableView!
    var userArray = [String]()
    var scoreArray = [Int]()
    
    
    
    func getWins(){
        //retieves the information for each user and then passes them into a dictionary
        let ref = Database.database().reference().child("users").observe(.value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                //print(child)
                var user = child.key as! String
                print(user)
                var wins = child.childSnapshot(forPath: "wins").value as! Int
                print(wins)
                
                self.leaderboard.updateValue(wins, forKey: user)
                print(self.leaderboard)
                
                self.RankUsers()
            }
            
        }
        
    

    }
    //sorts the list of users and their number of wins highest to lowest
    func RankUsers(){
        print("in rank user")
       leaderboard.sorted(by: <)
        print("under sort")
        print(leaderboard)
        userArray.removeAll()
        scoreArray.removeAll()
        for person in leaderboard{
            print("in for loop")
            let key = person.key
            let value = person.value
            
            userArray.append(key)
            scoreArray.append(value)
            print(userArray)
            
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // displays the number of rows in the table
        return scoreArray.count
    }
    
    //determines what will be in each cell of the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(userArray[indexPath.row])  Wins:  \(scoreArray[indexPath.row])"
        return cell!
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        getWins()

        // Do any additional setup after loading the view.
    }
    // reloads the table data once the screen appears
    override func viewDidAppear(_ animated: Bool) {
        self.LeaderBoardTable.reloadData()
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
