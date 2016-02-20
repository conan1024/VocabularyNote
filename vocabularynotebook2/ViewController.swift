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
    @IBOutlet var decidedButton: UIButton!
    
    var count:Int = 0
    var isAnswer : Bool = false
    var talker = AVSpeechSynthesizer()

    var mondailist : [[String]] = [[]]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initquestion()
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initquestion()
        nyuuryoku.delegate = self
    }
    
    func initquestion(){
        count = 0
        //userdefaultが空かどうかを確認
        if((NSUserDefaults.standardUserDefaults().objectForKey("wordDic")) == nil){
            //            NSUserDefaults.standardUserDefaults().setObject(mondailist, forKey:"wordDic")
            //            NSUserDefaults.standardUserDefaults().synchronize()
            let delay = 0.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("toMoveVC", sender: nil)
            })
        }else{
            //mondailistにuserdefaultからよみこむ
            mondailist = (NSUserDefaults.standardUserDefaults().objectForKey("wordDic") as! [[String]])
            mondai.text = mondailist[0][0]
            //println(arr);
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
        
        if isAnswer != true  {
            //入力させた後の正解・不正解の動作
            
            NSLog("hogeの中身は。。。%@",mondailist[count][1])
            NSLog("textFieldの中身は。。。%@",nyuuryoku.text!)
            
            mondailist[count][1] = self.removeLineBreak(mondailist[count][1])
            
            if mondailist[count][1] == nyuuryoku.text {
                /*正解の時：次の問題を出す
                mondailistから一時削除(リセットで元に戻せる)*/
                mondailist.removeAtIndex(count)
                let emptyCheck = mondailist.isEmpty
                if  emptyCheck {
                    self.performSegueWithIdentifier("toMoveVC", sender: nil)
                    nyuuryoku.text = ""
                    NSLog("正解しました１")
                    self.speach()
                    return
                }
                mondai.text = mondailist[count][0]
                kotae.text = ""
                isAnswer = false
                nyuuryoku.text = ""
                NSLog("正解しました２")
                
            } else {
                /*不正解の時：次の問題を出す*/
                kotae.text = mondailist[count][1]
                isAnswer =  true
                count++
                nyuuryoku.text = ""
                NSLog("不正解です")
            }
        } else {
            mondai.text = mondailist[count][0]
            kotae.text = ""
            nyuuryoku.text = ""
            isAnswer = false
        }
        
        
        //カウントが問題のリストを超えた時・・・画面遷移を行う
        if mondailist.count <= count{
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
            self.decidedButton.hidden = false
            
            return
        }
        
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
        self.speach()
        
    }
    
    func speach() {
        // 話す内容をセット
        let utterance = AVSpeechUtterance(string:self.kotae.text!)
        // 言語を日本に設定
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        // 実行
        self.talker.speakUtterance(utterance)
    }
    
    @IBAction func didTapAddButton() {
        self.performSegueWithIdentifier("toMoveVC", sender: nil)
    }
    
    func segueToMoveVC() {
        self.performSegueWithIdentifier("toMoveVC", sender: nil)
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



}

