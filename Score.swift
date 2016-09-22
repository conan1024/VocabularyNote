//
//  Result.swift
//  WORDLE
//
//  Created by Masanari Miyamoto on 2016/07/27.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit

class Score: UIViewController {
    
    @IBOutlet var scoreLabel: UILabel!
    
    let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = NSString(format: "%.2f％", appDel.correctRate)as String
    }
    
    @IBAction func pushRepeatButton(){
        appDel.isReset = true
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func pushTopButton(){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
