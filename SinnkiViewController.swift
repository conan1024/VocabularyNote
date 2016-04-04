
//
//  SinnkiViewController.swift
//  vocabularynotebook2
//
//  Created by Masanari Miyamoto on 2016/02/20.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit

class SinnkiViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource  {
    
    @IBOutlet var textfield : UITextField!
    @IBOutlet var languagePickerView : UIPickerView!
    
    //空の配列を用意する
    var stringArray : [String] = []
    
    //中身を確認するためのnum
    var num = 0
    
    var language = "日本語"
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let languageselect : [String] = ["日本語","英語(English)","中国語(中文)","韓国語(한국어)","ドイツ語(Deutsch)","フランス語(Français)","ロシア語(Русский язык)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagePickerView.delegate = self
        languagePickerView.dataSource = self
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageselect.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return languageselect[row] as String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("列: \(row)")
        print("値: \(languageselect[row])")
        language = languageselect[row]
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
    //重複判定
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //saveText()
        return true
    }
    
    @IBAction func modoru(){
        saveText()
        //        NSUserDefaults.standardUserDefaults().setObject(stringArray, forKey:"openKey");
        //        NSUserDefaults.standardUserDefaults().synchronize();
    }
    
    //配列に保存する
    func saveText(){
        for ( var i = 0; i < stringArray.count;i++ ) {
            if textfield.text == stringArray[i]{
                NSLog("かぶっています")
                let alert: UIAlertController = UIAlertController(title: "登録できません", message: "すでに同じ名前の物があります。\n別の名前に変えて下さい。", preferredStyle:  UIAlertControllerStyle.Alert)
                
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("OK")
                })
                alert.addAction(defaultAction)
                presentViewController(alert, animated: true, completion: nil)
                return
            }
        }
        stringArray.append(self.textfield.text!)
        
        //配列をopenKeyで保存
        defaults.setObject(stringArray, forKey: "openKey")
        defaults.setObject(language, forKey: self.textfield.text! + "langKey")
        NSLog("aaaaaaa%@",defaults.objectForKey(self.textfield.text! + "langKey") as! String)
        defaults.synchronize()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
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
