//
//  MakeViewController.swift
//  vocabularynotebook2
//
//  Created by Masanari Miyamoto on 2016/02/20.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit

class MakeViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var mondaiTextView: UITextView!
    @IBOutlet var kotaeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        
        return true
        
    }
    
    @IBAction func save(){
        //前までの事柄を読み込み
        var arr = [[String]]()
        
        if((NSUserDefaults.standardUserDefaults().objectForKey("wordDic")) != nil){
            arr = (NSUserDefaults.standardUserDefaults().objectForKey("wordDic") as! [[String]])
        }
        //追加
        let question:[String] = [mondaiTextView!.text,kotaeTextView!.text]
        
        arr.append(question)
        
        //以下の事柄を保存
        //let jumpArr = ["hop","step","jump"]
        NSUserDefaults.standardUserDefaults().setObject(arr, forKey:"wordDic");
        NSUserDefaults.standardUserDefaults().synchronize();
        
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    /*
    UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    */
    func textFieldDidBeginEditing(textField: UITextField){
        print("textFieldDidBeginEditing:" + textField.text!)
    }
    
    /*
    UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    */
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing:" + textField.text!)
        
        return true
    }
    
    /*
    改行ボタンが押された際に呼ばれるデリゲートメソッド.
    */
    func TextFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
