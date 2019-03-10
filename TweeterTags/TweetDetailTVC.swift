//
//  TweetDetailTVC.swift
//  TweeterTags
//
//  Created by Maeve Lynskey on 10/03/2019.
//  Copyright © 2019 COMP47390-41550. All rights reserved.
//

import UIKit

class TweetDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var mentionNameLabel: UILabel!
    
}


class TweetDetailTVC: UITableViewController {
    
    enum SectionTypes: CaseIterable {
        case users, hashtags, links
    }
    
    var media = [TwitterMedia]()
    var hashtags = [TwitterMention]()
    var urls = [TwitterMention]()
    var userMentions = [TwitterMention]()

    
    func getSection(forSection: Int) -> SectionTypes {
        return SectionTypes.allCases[forSection]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch getSection(forSection: section) {
        case .hashtags:
            return hashtags.count
        case .links:
            return urls.count
        case .users:
            return userMentions.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
            switch getSection(forSection: section) {
            case .hashtags:
                return "Hashtags"
            case .links:
                return "Links"
            case .users:
                return "Users"
            }
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetDetailsCell", for: indexPath) as! TweetDetailTableViewCell
        
        switch getSection(forSection: indexPath.section) {
        case .hashtags:
            if hashtags.count > 0 {
                let hash = hashtags[indexPath.row]
                cell.mentionNameLabel.text = hash.keyword
            }
            break
        case .links:
            if urls.count > 0 {
                let url = urls[indexPath.row]
                cell.mentionNameLabel.text = url.keyword
            }
            break
        case .users:
            if userMentions.count > 0 {
                let user = userMentions[indexPath.row]
                cell.mentionNameLabel.text = user.keyword
            }
            break
        }
        
        return cell
    }
    
 
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
