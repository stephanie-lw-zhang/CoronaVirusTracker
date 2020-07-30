//
//  NewsTableViewController.swift
//  CoronavirusTracker
//
//  Created by codeplus on 3/29/20.
//  Copyright © 2020 Alamance. All rights reserved.
//

import UIKit
class myCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var newsTitle: UILabel!
    var url: String!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var sourceLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowOffset = CGSize(width: 1, height: 3)
        containerView.layer.shadowRadius = 4
        newsImage.layer.cornerRadius = 10
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class NewsTableViewController: UITableViewController {
    struct newsArticle:Codable{
        var status: String?
        var totalResults: Int?
        var articles: [articleDetails]
      }
    
    struct articleDetails:Codable{
        var title: String?
        var url: String?
        var urlToImage: String?
        var source: sourceDetails
    }
    
    struct sourceDetails:Codable{
        var id: String?
        var name: String?
    }
    
    var newsData: [articleDetails] = []
    
    func getData(){
        
        let mySession = URLSession(configuration: URLSessionConfiguration.default)

                    let url = URL(string: "https://newsapi.org/v2/top-headlines?q=coronavirus&language=en&apiKey=986ab68be4ce4c158c097ccd3aef25c7")!

                    let task = mySession.dataTask(with: url) { data, response, error in

                                // ensure there is no error for this HTTP response
                                guard error == nil else {
                                    DispatchQueue.main.async {
                                        let alert1 = UIAlertController(title: "Network Error", message: "Please connect to a network to view newsfeed.", preferredStyle: .alert)
                                        alert1.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        self.present(alert1, animated: true)
                                    }
                                    print ("error: \(error!)")
                                    return
                                }

                                // ensure there is data returned from this HTTP response
                                guard let jsonData = data else {
                                    print("No data")
                                    return
                                }
                                
                                print("Got the data from network")
                    // 4. DECODE THE RESULTING JSON
                    //
                                let decoder = JSONDecoder()

                                do {
                                    // decode the JSON into our array of todoItem's
//                                    let allTasks = try decoder.decode([newsArticle].self, from: jsonData)
                                    let general = try decoder.decode(newsArticle.self, from: jsonData)
//                                     print("Status: \(general.status ?? "none")")
//                                    print("\(general.articles)")
                                            
                                
                                    
                                    for each in general.articles {
                                        if !self.newsData.contains(where: {$0.title == each.title}){
                                            self.newsData.append(each)
                                        }
//                                        print("Title: \(each.title ?? "none")")
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
//                                        print(self.newsData.count)
                                        
                                    }
                                    
                                    
                                    
                                } catch {
                                    print("JSON Decode error")
                                }
                            }

                            // actually make the http task run.
        task.resume()
        
    }
    
    
    override func viewDidLoad() {
        getData()
//        print(newsData.count)
        super.viewDidLoad()
        self.tableView.rowHeight = 140
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        print(newsData.count)
        return newsData.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! myCustomTableViewCell

        // Configure the cell...
        cell.newsTitle.text = newsData[indexPath.row].title ?? "n/a"
        cell.url = newsData[indexPath.row].url ?? "wwww.google.com"
        cell.sourceLabel.text = " \(newsData[indexPath.row].source.name ?? "n/a") "
        
        if newsData[indexPath.row].urlToImage == ""{
            newsData[indexPath.row].urlToImage = "https://lh3.googleusercontent.com/proxy/d21XuPCNRLe_c5-lCtqUkgcoAF-ptgu5LqRL0UuT0ziaQ8HuYdAoQ3gFVmfhSaqH9b2G7t9PKcqscghAYydU66JIvZatQLHQK_7v1Vy0AJ246BmzwvRk6fH1lPisupYvtJoiwMXNWZ8wF9zpzpVDKGmi3amC5YNuMaQ6ACSOGCZmUTRDz7vPBcWtVEWVDis8MSqjDMzaucx54_wHk1UDeny0bw"
        }
        
        let data = try? Data(contentsOf: URL(string: newsData[indexPath.row].urlToImage ?? "https://lh3.googleusercontent.com/proxy/d21XuPCNRLe_c5-lCtqUkgcoAF-ptgu5LqRL0UuT0ziaQ8HuYdAoQ3gFVmfhSaqH9b2G7t9PKcqscghAYydU66JIvZatQLHQK_7v1Vy0AJ246BmzwvRk6fH1lPisupYvtJoiwMXNWZ8wF9zpzpVDKGmi3amC5YNuMaQ6ACSOGCZmUTRDz7vPBcWtVEWVDis8MSqjDMzaucx54_wHk1UDeny0bwr")!)
        if let imageData = data {
            cell.newsImage.image = UIImage(data: imageData)
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // and cast it to the correct class type (i.e. focusAnimalViewController)
        let destVC = segue.destination as! NewsArticleTableViewController
        let myRow = tableView!.indexPathForSelectedRow
        let myCurrCell = tableView!.cellForRow(at: myRow!) as! myCustomTableViewCell
        destVC.articleURL = (myCurrCell.url)!
        // Pass the selected object to the new view controller.

        
    }
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
