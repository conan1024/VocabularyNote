//
//  KekkaViewController.swift
//  vocabularynotebook2
//
//  Created by Masanari Miyamoto on 2016/02/20.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit

class KekkaViewController: UIViewController {
    
    @IBOutlet var result: UILabel!
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        result.text = NSString(format: "%.2f％", appDel.answerrate)as String

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func quizback(){
        appDel.isReset = true
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func topback(){
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
