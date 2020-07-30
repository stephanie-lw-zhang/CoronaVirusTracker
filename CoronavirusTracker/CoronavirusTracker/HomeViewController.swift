//
//  HomeViewController.swift
//  CoronavirusTracker
//
//  Created by codeplus on 3/29/20.
//  Copyright © 2020 Alamance. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBAction func CDCUpdates(_ sender: Any) {
        if let url = URL(string: "https://www.cdc.gov/coronavirus/2019-ncov/index.html") {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func aboutButton(_ sender: Any) {
        if let url = URL(string: "https://www.who.int/emergencies/diseases/novel-coronavirus-2019") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func washTimerButton(_ sender: Any) {
    }
    
    @IBAction func checkSymptomsButton(_ sender: Any) {
       if let url = URL(string: "https://www.who.int/health-topics/coronavirus#tab=tab_3") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func positiveResultButton(_ sender: Any) {
    }
    
    
    
    @IBOutlet weak var tipView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tipView.layer.shadowColor = UIColor.black.cgColor
        tipView.layer.shadowOpacity = 0.2
        tipView.layer.shadowOffset = CGSize(width: 1, height: 3)
        tipView.layer.shadowRadius = 4
        
        //set today's date
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        dateLabel.text = formatter.string(from: currentDate)
        
        if let tip = tips.randomElement() {
            tipLabel.text = tip
        }
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
