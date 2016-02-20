
//
//  SinnkiViewController.swift
//  vocabularynotebook2
//
//  Created by Masanari Miyamoto on 2016/02/20.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit

class SinnkiViewController: UIViewController,UITextFieldDelegate  {
    
    @IBOutlet var textfield : UITextField!
    
    //空の配列を用意する
    var stringArray : [String] = []
    
    //中身を確認するためのnum
    var num = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // Do any additional setup after loading the view.
        
        textfield.delegate = self
        
        //昔"openKey"という鍵で保存したかどうか確認
        if((defaults.objectForKey("openKey")) != nil){
            
            //objectsを配列として確定させ、前回の保存内容を格納
            let objects = defaults.objectForKey("openKey") as? [String]
            
            //各名前を格納するための変数を宣言
            var nameString:AnyObject
            
            //前回の保存内容が格納された配列の中身を一つずつ取り出す
            for nameString in objects!{
                //配列に追加していく
                stringArray.append(nameString as String)
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        saveText()
        return true
    }
    
    @IBAction func modoru(){
        
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    //配列に保存する
     func saveText(){
        
        stringArray.append(self.textfield.text!)
        
        //配列をopenKeyで保存
        defaults.setObject(stringArray, forKey: "openKey")
        defaults.synchronize()

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
