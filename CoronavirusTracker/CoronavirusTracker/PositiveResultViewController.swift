//
//  PositiveResultViewController.swift
//  CoronavirusTracker
//
//  Created by Stephanie Zhang on 4/11/20.
//  Copyright © 2020 Alamance. All rights reserved.
//

import UIKit
import MessageUI
import Contacts

class PositiveResultViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    @IBOutlet weak var sendMsgTipView: UIView!
    
    @IBAction func shareAction(_ sender: Any) {
        
        if(MFMessageComposeViewController.canSendText()){
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "Hi, I've tested positive for the Coronavirus. If we've been in contact anytime in the past two weeks, I recommend you self isolate or get tested. This is an automated message.";
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        } else {
            //pop up sms services are not available at this time
            showMessagingAlert()
//            print("sms services are not available")
        }
    }
    
    func showMessagingAlert (){
            let alert = UIAlertController(title: "SMS services are not available", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
            case .cancelled:
                print("Message was cancelled")
                dismiss(animated: true, completion: nil)
            case .failed:
                print("Message failed")
                dismiss(animated: true, completion: nil)
            case .sent:
                print("Message was sent")
                dismiss(animated: true, completion: nil)
            default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendMsgTipView.layer.shadowColor = UIColor.black.cgColor
        sendMsgTipView.layer.shadowOpacity = 0.2
        sendMsgTipView.layer.shadowOffset = CGSize(width: 1, height: 3)
        sendMsgTipView.layer.shadowRadius = 4
        // Do any additional setup after loading the view.
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
