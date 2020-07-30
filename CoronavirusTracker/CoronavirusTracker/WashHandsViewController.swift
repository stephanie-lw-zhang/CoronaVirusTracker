//
//  WashHandsViewController.swift
//  CoronavirusTracker
//
//  Created by codeplus on 4/6/20.
//  Copyright © 2020 Alamance. All rights reserved.
//

import UIKit

class WashHandsViewController: UIViewController {

    var isTimerSelected = false
    
    @IBOutlet weak var startPause: UIButton!
    @IBOutlet weak var counterView: UIView!
    @IBOutlet weak var washingTipsView: UIView!
    @IBOutlet weak var washingTipLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func startTimerButton(_ sender: Any) {
        if isTimerSelected == false{
            stopwatch.toggle()
            startPause.backgroundColor = .lightGray
            isTimerSelected = true
        }
    /*    isTimerSelected = !isTimerSelected
        if isTimerSelected{
            startPause.setTitle("Resume", for: .normal)
          //  NotificationCenter.default.addObserver(self, selector: #selector(updateStopwatchLabel(notification:)), name: NSNotification.Name("updateStopwatch"), object: nil)
        }
        else{
            startPause.setTitle("Pause", for: .normal)
         //   NotificationCenter.default.removeObserver(self)
        }
        stopwatch.toggle() */
    }
    
    //Does not stop the timer
    private lazy var stopwatch = Stopwatch(timeUpdated: { timeInterval in
                NotificationCenter.default.post(name: NSNotification.Name("updateStopwatch"), object: nil, userInfo: ["time":timeInterval])
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        counterView.layer.borderColor = UIColor.systemTeal.cgColor
        counterView.layer.borderWidth = 2.0
        
        washingTipsView.layer.shadowColor = UIColor.black.cgColor
        washingTipsView.layer.shadowOpacity = 0.2
        washingTipsView.layer.shadowOffset = CGSize(width: 1, height: 3)
        washingTipsView.layer.shadowRadius = 4
        NotificationCenter.default.addObserver(self, selector: #selector(updateStopwatchLabel), name: NSNotification.Name("updateStopwatch"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        stopwatch.stop()
    }
    
    @objc func updateStopwatchLabel(notification: NSNotification) {
        let time = notification.userInfo!["time"] as! TimeInterval
        
        
        if self.timerLabel.text != "0"{
            self.timerLabel.text = self.timeString(from: time)
        }
        
    }
    
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = 20 - Int(timeInterval.truncatingRemainder(dividingBy: 60))
        return String(seconds)
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

class Stopwatch {
    
    // MARK: Private Properties
    private let step: Double
    private var timer: Timer?
    
    //The time when counting was started
    private(set) var from: Date?
    //The time when counting was stopped
    private(set) var to: Date?
    
    // The time when user pause timer last one
    private var timeIntervalTimelapsFrom: TimeInterval?
    // The total time before user paused timer
    private var timerSavedTime: TimeInterval = 0
    
    typealias TimeUpdated = (_ time: Double)->Void
    let timeUpdated: TimeUpdated
    
    // MARK: Public Properties
    
    var isPaused: Bool {
        return timer == nil
    }
    
    //MARK: Initialization
    
    init(step: Double = 1.0, timeUpdated: @escaping TimeUpdated) {
        //   self.from = Date(timeIntervalSinceNow: 20)
        //   self.to = Date(timeIntervalSinceNow: 0)
        self.step = step
        self.timeUpdated = timeUpdated
    }
    
    deinit {
        print("Stopwatch successfully deinited")
        deinitTimer()
    }
    
    func toggle() {
        guard timer != nil else {
            initTimer()
            return
        }
        deinitTimer()
    }
    
    func stop() {
        deinitTimer()
        from = nil
        to = nil
        timerSavedTime = 0
        timeUpdated(0)
    }
    
    private func initTimer() {
        let action: (Timer)->Void = { [weak self] timer in
            guard let strongSelf = self else {
                return
            }
            let to = Date().timeIntervalSince1970
            let timeIntervalFrom = strongSelf.timeIntervalTimelapsFrom ?? to
            let time = strongSelf.timerSavedTime + (to - timeIntervalFrom)
            strongSelf.timeUpdated(round(time))
        }
        if from == nil {
            from = Date()
        }
        if timeIntervalTimelapsFrom == nil {
            timeIntervalTimelapsFrom = Date().timeIntervalSince1970
        }
        timer = Timer.scheduledTimer(withTimeInterval: step,
                                                                 repeats: true, block: action)
    }
    
    private func deinitTimer() {
        //Saving last timelaps
        if let timeIntervalTimelapsFrom = timeIntervalTimelapsFrom {
            let to = Date().timeIntervalSince1970
            timerSavedTime += to - timeIntervalTimelapsFrom
        }
        //Invalidating
        timer?.invalidate()
        timer = nil
        timeIntervalTimelapsFrom = nil
    }
    
    //// resource used: http://www.popcornomnom.com/countdown-timer-in-swift-5-for-ios/
}
