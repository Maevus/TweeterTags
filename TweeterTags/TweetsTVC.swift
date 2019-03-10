//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by Maeve Lynskey on 06/03/2019.Ò
//  Copyright © 2019 COMP47390. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    @IBOutlet weak var userAvaterImage: UIImageView!
    @IBOutlet weak var tweeterScreenNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var tweetDateLabel: UILabel!
    
}


class TweetsTVC: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var twitterQueryTextField: UITextField!
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue) {}
    
    var twitterQueryText: String? = "#UCD"  {
        didSet {
            print ("\(twitterQueryText!)")
            twitterQueryTextField.text = twitterQueryText!
            refresh()
            }
    }
    
    var tweets = [TwitterTweet]() {
        didSet {
            if tableView.window != nil {
                tableView.reloadData()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "\n"{
            textField.resignFirstResponder()
            return false
        }
        twitterQueryText = textField.text
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.white
    }
    
    
    func refresh() {
        let request = TwitterRequest(search: twitterQueryText!, count: 8)
                request.fetchTweets { (tweets) -> Void in
                    DispatchQueue.main.async { () -> Void in
                        self.tweets = tweets }
                    }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweets.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTVCell", for: indexPath) as! TweetTableViewCell
        let tweet = self.tweets[indexPath.row]
        
        cell.tweeterScreenNameLabel.text = "@"+tweet.user.screenName
        cell.tweetDateLabel.text = getFormattedTime(date:tweet.created)
        
        let tweetText = NSMutableAttributedString(string: tweet.text)
      
        // colour hastags blue
        for mention in tweet.hashtags {
            tweetText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: mention.nsrange)
        }
        
        // colour mentions green
        for mention in tweet.userMentions {
            tweetText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: mention.nsrange)
        }
        
        // colour urls red
        for mention in tweet.urls {
            tweetText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: mention.nsrange)
        }
        
        cell.tweetContentLabel.attributedText = tweetText
        
        cell.userAvaterImage.image = #imageLiteral(resourceName: "ucd")
        if let url = tweet.user.profileImageURL {
            fetchUserAvatar(url) { (data) in
                if let imageData = data {
                    DispatchQueue.main.async {
                        cell.userAvaterImage.image = UIImage(data: imageData)
                    }
                }
            }
        }

        return cell
    }

    func fetchUserAvatar(_ url: URL, completion: @escaping (_ data: Data?) -> Void) {
        let request = URLRequest(url:url)
        let config = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration:config)
        let task = session.downloadTask(with: request, completionHandler: { (location, response, error) -> Void in
            var data: Data?
            if error == nil {
                data = try? Data(contentsOf: location!)
            }
            completion(data)
        })
        task.resume()
    }
    
    
    func getFormattedTime (date:Date) -> String {
        
        let date = date.description
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let dateObj = df.date(from: date)
        df.dateFormat = "HH:mm"
        
        return df.string(from: dateObj!)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            let tweet = tweets[indexPath.row]
            let tweetTVC = segue.destination as! TweetDetailTVC
 
            tweetTVC.hashtags = tweet.hashtags
            tweetTVC.media = tweet.media
            tweetTVC.urls = tweet.urls
            tweetTVC.userMentions = tweet.userMentions
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        twitterQueryTextField.delegate = self
        refresh()
        
    }
}

