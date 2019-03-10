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
        
            var title = ""
        
            switch getSection(forSection: section) {
            case .hashtags:
                if hashtags.count > 0 {
                    title =  "Hashtags"
                }
            case .links:
                if urls.count > 0 {
                    title  =  "Links" }
            case .users:
                if  userMentions.count > 0 {
                      return "Users"
                }
            }
        
        return title
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if getSection(forSection: indexPath.section) == SectionTypes.links {
            if urls.count > 0 {
                let url = urls[indexPath.row].keyword
                UIApplication.shared.open(NSURL(string:url)! as URL)
            }
        }
    }
    
     // MARK: - Navigation
    
    // unwindToMain
    override func shouldPerformSegue(withIdentifier: String?, sender: Any?) -> Bool {
        
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            let section = indexPath.section
            if getSection(forSection: section) != SectionTypes.links {
                return true
            } else  {
                return false
            }
        } else {
            return true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let tweetTVC = segue.destination as! TweetsTVC
        
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
             let section = indexPath.section
            
             switch getSection(forSection: section) {
             case .hashtags:
                tweetTVC.twitterQueryText = hashtags[indexPath.row].keyword
                break
             case .users:
                tweetTVC.twitterQueryText = userMentions[indexPath.row].keyword
                break
             default:
                break
    
            }
            
        }
        
    }
}
