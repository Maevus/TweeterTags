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
    
    var twitterQueryText: String? = "#UCD"  {
        didSet {
             // code here?
            }
    }
    
    var tweets = [TwitterTweet]() {
        didSet {
            if tableView.window != nil {
                tableView.reloadData()
            }
            print ("\(tweets.count))")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        
        twitterQueryTextField.delegate = self
        refresh()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func refresh() {
        let request = TwitterRequest(search: twitterQueryText!, count: 8)
                request.fetchTweets { (tweets) -> Void in
                    DispatchQueue.main.async { () -> Void in
                        self.tweets = tweets }
                    }
    }
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweets.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTVCell", for: indexPath) as! TweetTableViewCell
        let tweeter = self.tweets[indexPath.row]
        
        cell.tweeterScreenNameLabel.text = tweeter.user.screenName
        cell.tweetContentLabel.text = tweeter.text
        cell.tweetDateLabel.text = getFormattedTime(date:tweeter.created)
        
        cell.userAvaterImage.image = #imageLiteral(resourceName: "ucd")

        
        if let url = tweeter.user.profileImageURL {
            fetchUserAvatar(url) { (data) in
               // Thread.sleep(forTimeInterval: 3)
                print("fetching thumbnail for row: \(indexPath.row)")
                if let imageData = data {
                    //print("caching thumbnail for row: \(indexPath.row)")
                    //self.thumbnailCache[cacheID] = fetchData
                    //imageData = fetchData
                    DispatchQueue.main.async {
                        cell.userAvaterImage.image = UIImage(data: imageData)
                    }
                }
            }
        }

        return cell
    }

    // TODO move to model? 
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

