//
//  NewVocabularyNotebook.swift
//  WORDLE
//
//  Created by Masanari Miyamoto on 2016/07/27.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit

class NewVocabularyNotebook: UIViewController {
    
    var textField = UITextField(frame: CGRect(x: 0, y: 0, width: 320, height: 30))
    
    @IBOutlet var languagePickerView : UIPickerView!
    @IBOutlet var backGroundImage : UIImageView!
    
    // タップ開始時のスクロール位置格納用
    var startPoint : CGPoint = CGPoint()
    
    //入力欄の位置
    var position : CGFloat = 0
    
    let backgroundScrollView = UIScrollView()
    
    //単語帳の名前
    var vocabularyNotebookNameArray : [String] = []
    
    var language = "日本語"
    let languageArray : [String] = ["日本語","英語(English)","中国語(中文)","韓国語(한국어)","ドイツ語(Deutsch)","フランス語(Français)","ロシア語(Русский язык)"]
    
    let defaults = UserDefaults.standard
    
    //画面が現れる度に起こる動作
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //キーボードの設定(出てきた時と引っ込んだ時)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(NewVocabularyNotebook.handleKeyboardWillBeShownNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(NewVocabularyNotebook.handleKeyboardWillBeHiddenNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    //viewWillAppearの後に行われる処理
    override func viewDidAppear(_ animated: Bool) {
        
        //TextFieldの初期設定
        textField.delegate = self
        
        //vocabularyNotebookNameArrayを呼び出す
        if((defaults.object(forKey: "openKey")) != nil){
            
            let objects = defaults.object(forKey: "openKey") as? [String]
            
            var nameString:AnyObject
            
            for nameString in objects!{
                
                vocabularyNotebookNameArray.append(nameString as String)
            }
        }
    }
    
    //画面が最初に現れた時のみの動作
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PickerViewの初期設定
        languagePickerView.delegate = self
        languagePickerView.dataSource = self
        
        backgroundScrollView.frame = self.view.frame
        backgroundScrollView.delegate = self
        
        backgroundScrollView.contentSize = CGSize(width: 250,height: 1000)
        self.view.addSubview(backgroundScrollView)
        
        textField.placeholder = "PUT IN THE TITLE"
        textField.font = UIFont(name: "HOKKORI", size: 20)
        
        // UITextFieldの表示する位置を設定する.
        textField.layer.position = CGPoint(x:self.view.bounds.width/2 ,y:languagePickerView.frame.origin.y + 198)
        
        backgroundScrollView.addSubview(textField)
        
        // 枠を表示する.
        textField.borderStyle = UITextBorderStyle.roundedRect
        
        textField.tintColor =  UIColor.blue
        
        self.view.sendSubview(toBack: backgroundScrollView)
        self.view.sendSubview(toBack: backGroundImage)
        
        let myTap = UITapGestureRecognizer(target: self, action: #selector(NewVocabularyNotebook.tapGesture(_:)))
        self.view.addGestureRecognizer(myTap)
    }
    
    func tapGesture(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
        textField.resignFirstResponder()
    }
}

// MARK: - PickerViewDelegate,PickerViewDataSource
extension NewVocabularyNotebook: UIPickerViewDelegate, UIPickerViewDataSource{
    //PickerViewの設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageArray[row] as String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("列: \(row)")
        print("値: \(languageArray[row])")
        language = languageArray[row]
    }
}

// MARK: - ScrollViewDelegate
extension NewVocabularyNotebook: UIScrollViewDelegate{
    
    //画面の任意の場所を押した時、キーボードが引っ込む動作
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //キーボードの座標(キーボードがTextFieldとかぶらないように)
    func handleKeyboardWillBeShownNotification(_ notification: Notification) {
        
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let txtLimit = textField.frame.origin.y + textField.frame.height + 8.0
        let kbdLimit = myBoundSize.height - (keyboardScreenEndFrame.size.height)
        
        
        print("テキストフィールドの下辺：(\(txtLimit))")
        print("キーボードの上辺：(\(kbdLimit))")
        //            position = scrollView.contentOffset.y
        //            scrollView.contentOffset.y = makeAnswerTextField.frame.origin.y - 50
        if txtLimit >= kbdLimit {
            backgroundScrollView.contentOffset.y = txtLimit - kbdLimit
            //position = txtLimit - kbdLimit
        }
    }
    
    //キーボードが閉じられるときの呼び出しメソッド
    func handleKeyboardWillBeHiddenNotification(_ notification:Notification){
        backgroundScrollView.contentOffset.y = 0
        //            position = 0
    }
}


// MARK: - textfield
extension NewVocabularyNotebook: UITextFieldDelegate{
    
    //UITextFieldが編集された直後に呼ばれるデリゲートメソッド.
    func textFieldDidBeginEditing(_ textField: UITextField){
        print("textFieldDidBeginEditing:" + textField.text!)
    }
    
    
    //UITextFieldが編集終了する直前に呼ばれるデリゲートメソッド.
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing:" + textField.text!)
        
        return true
    }
    
    //改行ボタンが押された際に呼ばれるデリゲートメソッド.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - pushButton
extension NewVocabularyNotebook {
    @IBAction func pushCreateButton(){
        saveText()
    }
    
    //配列に保存する
    func saveText(){
        for i in 0 ..< vocabularyNotebookNameArray.count {
            //重複判定
            if textField.text == vocabularyNotebookNameArray[i]{
                NSLog("かぶっています")
                let alert: UIAlertController = UIAlertController(title: "登録できません", message: "すでに同じ名前の単語帳があります。\n別の名前に変えて下さい。", preferredStyle:  UIAlertControllerStyle.alert)
                
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    (action: UIAlertAction!) -> Void in
                    print("OK")
                })
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)
                return
            }
        }
        vocabularyNotebookNameArray.append(self.textField.text!)
        
        defaults.set(vocabularyNotebookNameArray, forKey: "openKey")
        defaults.set(language, forKey: self.textField.text! + "langKey")
        NSLog("aaaaaaa%@",defaults.object(forKey: self.textField.text! + "langKey") as! String)
        defaults.synchronize()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pushBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
}
