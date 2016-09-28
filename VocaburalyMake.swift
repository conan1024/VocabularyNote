//
//  VocaburalyMake.swift
//  WORDLE
//
//  Created by Masanari Miyamoto on 2016/04/17.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit

class VocaburalyMake: UIViewController{
    
    //単語帳において問題を作る
    @IBOutlet var makeQuestionTextField: UITextField!
    //単語帳において答えを作る
    var makeAnswerTextField = UITextField(frame: CGRect(x: 0,y: 0,width: 225,height: 86))
    
    @IBOutlet var backGroundImage : UIImageView!
    @IBOutlet var questionCardImage : UIImageView!
    var answerCardImage = UIImageView(frame: CGRect(x: 0,y: 0,width: 305,height: 86))
    
    
    // タップ開始時のスクロール位置格納用
    var startPoint : CGPoint = CGPoint()
    
    //AppDelegate.swiftで宣言した変数を使用
    let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //選ばれた単語帳の中身
    var selectVocaburaly: String = ""
    
    //scrollView
    let scrollView = UIScrollView()
    
    //入力欄の位置
    var position : CGFloat = 0
    
    //画面が現れる度に起こる動作
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(VocaburalyMake.handleKeyboardWillBeShownNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(VocaburalyMake.handleKeyboardWillBeHiddenNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //画面が最初に現れた時のみの動作
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //selectVocaburalyはselectVocaburalyNotebookを使用しています
        selectVocaburaly = appDel.selectVocaburalyNotebook
        
        scrollView.frame = self.view.frame
        
        scrollView.contentSize = CGSize(width: 250,height: 1000)
        self.view.addSubview(scrollView)
        
        answerCardImage.image = UIImage(named: "WordDefaults.png")
        answerCardImage.layer.position = CGPoint(x: self.view.bounds.width/2, y: questionCardImage.frame.origin.y + 208)
        
        makeAnswerTextField.placeholder = "PUT IN THE ANSWER"
        makeAnswerTextField.font = UIFont(name: "HOKKORI", size: 20)
        
        // UITextFieldの表示する位置を設定する.
        makeAnswerTextField.layer.position = CGPoint(x:answerCardImage.frame.origin.x + 192.5 ,y:answerCardImage.frame.origin.y + 43)
        scrollView.addSubview(answerCardImage)
        scrollView.addSubview(makeAnswerTextField)
        
        makeAnswerTextField.tintColor =  UIColor.blue
        
        
        self.view.sendSubview(toBack: scrollView)
        self.view.sendSubview(toBack: answerCardImage)
        self.view.sendSubview(toBack: questionCardImage)
        self.view.sendSubview(toBack: backGroundImage)
        
        let myTap = UITapGestureRecognizer(target: self, action: #selector(VocaburalyMake.tapGesture(_:)))
        self.view.addGestureRecognizer(myTap)
    }
    
    func tapGesture(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
        makeQuestionTextField.resignFirstResponder()
        makeAnswerTextField.resignFirstResponder()
    }
    
    @IBAction func pushSaveButton(){
        //前までの事柄を読み込み(2次元配列)
        var arr = [[String]]()
        
        if((UserDefaults.standard.object(forKey: selectVocaburaly)) != nil){
            arr = (UserDefaults.standard.object(forKey: selectVocaburaly) as! [[String]])
        }
        
        //もし、QuestionMake/AnswerMakeに何も書かれていなかった場合、アラートを表示する
        if makeQuestionTextField.text == "" || makeAnswerTextField.text == ""{
            let alert: UIAlertController = UIAlertController(title: "追加できません", message: "問題と答えのどちらにも\n入力をして下さい。", preferredStyle:  UIAlertControllerStyle.alert)
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        //単語帳の中身を生成
        let makeVocaburaly:[String] = [makeQuestionTextField!.text!,makeAnswerTextField.text!]
        arr.append(makeVocaburaly)
        
        //以下の事柄を保存
        UserDefaults.standard.set(arr, forKey:selectVocaburaly)
        UserDefaults.standard.synchronize()
        
        //単語帳の中身が追加されました
        appDel.isAddVocaburaly = true
        
        //前の画面に戻る
        self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func pushBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //    @IBAction func pushTopButton(){
    //        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    //    }
}

// MARK: - textfield
extension VocaburalyMake: UITextFieldDelegate {
    
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

// MARK: - ScrollViewDelegate
extension VocaburalyMake: UIScrollViewDelegate {
    // ドラッグ(スクロール)しても y 座標は開始時から動かないようにする(固定)
    //    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    //        scrollView.scrollEnabled = false
    //    }
    //
    //    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        scrollView.contentOffset.y = 0
    //        scrollView.scrollEnabled = true
    //    }
}


// MARK: - KeyBoard
extension VocaburalyMake {
    //画面の任意の場所を押した時、キーボードが引っ込む動作
    @IBAction func tapScreen(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    //キーボードの座標(キーボードがTextFieldとかぶらないように)
    func handleKeyboardWillBeShownNotification(_ notification: Notification) {
        
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let txtLimit = makeAnswerTextField.frame.origin.y + makeAnswerTextField.frame.height + 08.0
        let kbdLimit = myBoundSize.height - (keyboardScreenEndFrame.size.height)
        
        
        print("テキストフィールドの下辺：(\(txtLimit))")
        print("キーボードの上辺：(\(kbdLimit))")
        //            position = scrollView.contentOffset.y
        //            scrollView.contentOffset.y = makeAnswerTextField.frame.origin.y - 50
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
            //position = txtLimit - kbdLimit
        }
    }
    
    //キーボードが閉じられるときの呼び出しメソッド
    func handleKeyboardWillBeHiddenNotification(_ notification:Notification){
        scrollView.contentOffset.y = 0
        //            position = 0
    }
}
