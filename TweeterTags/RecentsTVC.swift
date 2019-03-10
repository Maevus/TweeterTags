//
//  RecentsTVC.swift
//  TweeterTags
//
//  Created by Maeve Lynskey on 10/03/2019.
//  Copyright © 2019 COMP47390-41550. All rights reserved.
//

import UIKit

class SearchesTableViewCell: UITableViewCell {
    @IBOutlet weak var searchLabel: UILabel!

}

class RecentsTVC: UITableViewController {
    
    var searches: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let defaults: UserDefaults = UserDefaults.standard
        searches = defaults.stringArray(forKey: "twitterSearches")
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the maximum number of results
        return  searches.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchesCell", for: indexPath) as! SearchesTableViewCell
        
        if searches.count > 0 {
            cell.searchLabel.text = searches[searches.count - indexPath.row - 1]
        }

        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tweetTVC = segue.destination as! TweetsTVC
    
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            tweetTVC.twitterQueryText = searches[searches.count - indexPath.row - 1]
        }
    }
 
}
