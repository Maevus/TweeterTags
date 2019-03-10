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

    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTypes.allCases.count
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
    
    /*
     Hide unused headers by minimising them when they are not needed.
    */
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        var height: CGFloat = 21

        switch getSection(forSection: section) {
        case .hashtags:
            if hashtags.count < 1 {
                height = CGFloat.leastNonzeroMagnitude
            }
        case .links:
            if urls.count < 1 {
                height = CGFloat.leastNonzeroMagnitude
            }
        case .users:
            if userMentions.count < 1 {
                height = CGFloat.leastNonzeroMagnitude
            }
        }
        
        return height
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
   // }
  //  */

}
