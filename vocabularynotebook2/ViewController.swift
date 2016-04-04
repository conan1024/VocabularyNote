//
//  ViewController.swift
//  vocabularynotebook2
//
//  Created by Masanari Miyamoto on 2016/02/20.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var mondai: UILabel!
    @IBOutlet weak var kotae: UILabel!
    @IBOutlet weak var nyuuryoku: UITextField!
    @IBOutlet var scoreButton: UIButton!
    @IBOutlet var nextButton : UIButton!
    @IBOutlet var decidedButton : UIButton!
    
    var count:Int = 0
    var isAnswer : Bool = false
    var talker = AVSpeechSynthesizer()
    var answercount:Int = 0
    
    var language = ""
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    var mondailist : [[String]] = [[]]
    
    var selectedText: String!
    var correctnumber = 0.0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if appDel.isReset == true{
            
            appDel.allanswercount = 0
            nextButton.hidden = true
            decidedButton.hidden = false
            selectedText = appDel.selectedCellText
            correctnumber = appDel.correct
            
            initquestion()
        }
        
        // nextButton.hidden = true
        // decidedButton.hidden = false
        selectedText = appDel.selectedCellText
        correctnumber = appDel.correct
        print(selectedText)
        //
        //  initquestion()
        //mondailistの要素数が0だったら
        //initquestion()を呼び出す
        if mondailist.count == 0{
            initquestion()
        }
        
        if appDel.isAdd == true && appDel.allanswercount != 0{
            //追加した後の問題
            //
            if((NSUserDefaults.standardUserDefaults().objectForKey(selectedText)) != nil){
                let lastQuestions: [[String]] = NSUserDefaults.standardUserDefaults().objectForKey(selectedText) as! [[String]]
                mondailist.append(lastQuestions.last!)
                if mondai.text == "" {
                    mondai.text = mondailist[0][0]
                }
            }
            
            
            appDel.isAdd == false
        } else if appDel.isAdd == true && appDel.allanswercount == 0{
            initquestion()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        initquestion()
        appDel.allanswercount = 0
        
        nyuuryoku.delegate = self
        
        //        nextButton.hidden = true
        
        kotae.font = UIFont(name: "HOKKORI",size:24)
        mondai.font = UIFont(name: "HOKKORI",size:24)
        
        nextButton.hidden = true
        decidedButton.hidden = false
        selectedText = appDel.selectedCellText
        correctnumber = appDel.correct
        
        initquestion()
    }
    
    func initquestion(){
        count = 0
        //userdefaultが空かどうかを確認
        if((NSUserDefaults.standardUserDefaults().objectForKey(selectedText)) == nil){
            //            NSUserDefaults.standardUserDefaults().setObject(mondailist, forKey:"wordDic")
            //            NSUserDefaults.standardUserDefaults().synchronize()
            let delay = 0.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("toMoveVC", sender: nil)
            })
        }else{
            //mondailistにuserdefaultからよみこむ
            mondailist = (NSUserDefaults.standardUserDefaults().objectForKey(selectedText) as! [[String]])
            mondai.text = mondailist[0][0]
            //println(arr);
            
            appDel.allquiz = Double(mondailist.count)
            
            
        }
        //最初の問題を表示
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeLineBreak(string: String) -> String {
        var stringArray = string.componentsSeparatedByString("\n")
        return stringArray[0]
    }
    
    @IBAction func PushkousintButton(sender : UIButton) {
        print("カウントの回数")
        appDel.allanswercount++
        answercount++
        print(count)
        if isAnswer != true {
            //入力させた後の正解・不正解の動作
            
            NSLog("hogeの中身は。。。%@",mondailist[count][1])
            NSLog("textFieldの中身は。。。%@",nyuuryoku.text!)
            
            mondailist[count][1] = self.removeLineBreak(mondailist[count][1])
            
            
            if mondailist.count < count{
                print("count = \(count)")
                count = 0
                //            self.segueToMoveVC()
                
                //            if self.type == 1{
                //                // 表示
                //                self.decidedButton.hidden = false
                //            }else{
                //                // 非表示
                //                self.decidedButton.hidden = true
                //            }
                self.scoreButton.hidden = false
                
                return
            }
            
            
            decidedButton.hidden = true
            
            if mondailist[count][1] == nyuuryoku.text {
                
                
                /*正解の時：次の問題を出す
                mondailistから一時削除(リセットで元に戻せる)*/
                mondailist.removeAtIndex(count)
                
                //                count = 0
                correctnumber = correctnumber+1.0
                
                let emptyCheck = mondailist.isEmpty
                if  emptyCheck {
                    
                    if answercount == 0{
                        appDel.answerrate = 0
                        
                    }else if answercount < Int(appDel.allquiz){
                        
                        appDel.answerrate = (correctnumber/Double(appDel.allanswercount))*100.0
                        
                    }else {
                        appDel.answerrate = correctnumber/appDel.allanswercount*100.0
                        
                    }
                    performSegueWithIdentifier("score",sender: nil)
                    
                    self.performSegueWithIdentifier("score", sender: nil)
                    nyuuryoku.text = ""
                    NSLog("正解しました１")
                    //self.speach()
                    return
                }
                if mondailist.count <= count{
                    count = 0
                }
                mondai.text = mondailist[count][0]
                kotae.text = ""
                isAnswer = false
                nyuuryoku.text = ""
                NSLog("正解しました２")
                //正解数をカウント
                
                decidedButton.hidden = false
                
            } else {
                /*不正解の時：次の問題を出す*/
                kotae.text = mondailist[count][1]
                isAnswer =  true
                count++
                nyuuryoku.text = ""
                NSLog("不正解です")
                
                nextButton.hidden = false
            }
            
        } else {
            
            //不正解後に流れるところ
            
            mondai.text = mondailist[count][0]
            kotae.text = ""
            nyuuryoku.text = ""
            isAnswer = false
        }
        
        
        //カウントが問題のリストを超えた時・・・画面遷移を行う
        //        if mondailist.count <= count{
        //            print("count = \(count)")
        //            count = 0
        //            //            self.segueToMoveVC()
        //
        //            //            if self.type == 1{
        //            //                // 表示
        //            //                self.decidedButton.hidden = false
        //            //            }else{
        //            //                // 非表示
        //            //                self.decidedButton.hidden = true
        //            //            }
        //            self.scoreButton.hidden = false
        //
        //            return
        //        }
        
        //mondai.text = mondailist[0][1]
        
        //問題番号をカウントするぽ
        
        //        //答えがある時・・・次の問題を出す
        //        if  isAnswer {//問題を出す（count+1）・isAnswerをfalseにする
        //            mondai.text = mondailist[count][0]
        //            kotae.text = ""
        //            isAnswer = false
        //        }else{//答えを出す・isAnswerをtrueにする
        //            kotae.text = mondailist[count][1]
        //            isAnswer =  true
        //            count++
        //        }
        //self.speach()
    }
    
    
    
    @IBAction func didTapAddButton() {
        self.performSegueWithIdentifier("score", sender: nil)
    }
    
    func seguescore() {
        self.performSegueWithIdentifier("score", sender: nil)
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
        
        return true
    }
    @IBAction func tapScreen(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance:AVSpeechUtterance!)
    {
        print("***開始***")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!)
    {
        print("***終了***")
    }
    
    func speechSynthesizer(synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!)
    {
        let word = (utterance.speechString as NSString).substringWithRange(characterRange)
        print("Speech: \(word)")
    }
    
    func speach() {
        let utterance = AVSpeechUtterance(string:self.kotae.text!)
        language = NSUserDefaults.standardUserDefaults().objectForKey(selectedText + "langKey") as! String
        if language == "日本語"{
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        }else if language == "英語(English)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }else if language == "中国語(中文)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        }else if language == "韓国語(한국어)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        }else if language == "ドイツ語(Deutsch)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "da-DK")
        }else if language == "フランス語(Français)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        }else if language == "ロシア語(Русский язык)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
        }
        self.talker.speakUtterance(utterance)
    }
    
    @IBAction func voice(){
        self.speach()
    }
    
    func speach2() {
        let utterance = AVSpeechUtterance(string:self.mondai.text!)
        language = NSUserDefaults.standardUserDefaults().objectForKey(selectedText + "langKey") as! String
        if language == "日本語"{
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        }else if language == "英語(English)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }else if language == "中国語(中文)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        }else if language == "韓国語(한국어)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        }else if language == "ドイツ語(Deutsch)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "da-DK")
        }else if language == "フランス語(Français)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR")
        }else if language == "ロシア語(Русский язык)" {
            utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
        }
        self.talker.speakUtterance(utterance)
    }
    
    @IBAction func voice2(){
        self.speach2()
    }
    
    @IBAction func scoreMake(){
        
        if answercount == 0{
            appDel.answerrate = 0
            
        }else if answercount < Int(appDel.allquiz){
            
            appDel.answerrate = (correctnumber/Double(appDel.allanswercount))*100.0
            
        }else {
            appDel.answerrate = correctnumber/appDel.allanswercount*100.0
            
        }
        performSegueWithIdentifier("score",sender: nil)
        
    }
    
    @IBAction func nextHide(){
        nextButton.hidden = true
        decidedButton.hidden = false
        
        if mondailist.count <= count{
            count = 0
        }
        mondai.text = mondailist[count][0]
        kotae.text = ""
        nyuuryoku.text = ""
        isAnswer = false
    }
    
    @IBAction func back(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func next(sender : UIButton) {
        performSegueWithIdentifier("toMoveVC",sender: nil)
    }
    
    
    
    //ピーや
}