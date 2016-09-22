//
//  VocaburalyNotebook.swift
//  WORDLE
//
//  Created by Masanari Miyamoto on 2016/04/17.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit
import AVFoundation

class VocaburalyNotebook: UIViewController, UIGestureRecognizerDelegate {
    
    //単語帳においての問題
    @IBOutlet var questionLabel : UILabel!
    //単語帳においての答え
    @IBOutlet var answerLabel : UILabel!
    //単語帳において自分の答えを入力
    @IBOutlet var inputAnswer: UITextField!
    //単語帳において自分の答えを決定
    @IBOutlet var enterButton : UIButton!
    //enterButtonの画像
    @IBOutlet var enterButtonImage : UIImageView!
    //単語帳において次の問題に移動する
    @IBOutlet var nextButton : UIButton!
    //nextButtonの画像
    @IBOutlet var nextButtonImage : UIImageView!
    //単語帳においてスコア画面に移動する
    @IBOutlet var scoreButton: UIButton!
    
    //単語帳において、これが何問目か
    var nowQuestionNumber:Int = 0
    //単語帳において、自分が答えた回数
    var answerNumber:Int = 0
    //単語帳において、自分が正解した回数
    var correctNumber = 0.0
    
    //単語帳において問題に答えたかどうか
    //var isAnswer : Bool = false
    
    //NSUserDefaultsにおいて、選択した問題を把握するための鍵
    var selectQuestionKey: String = ""
    //問題の配列(リスト) (単語帳の全ての中身(各々の単語))
    var questionList : [[String]] = []
    
    //AVSpeechSynthesizerにおいての宣言
    var language = ""
    var talker = AVSpeechSynthesizer()
    
    
    //AppDelegate.swiftで宣言した変数を使用
    let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //画面が現れる度に起こる動作
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //isReset(問題がリセットされた)時の動作
        if appDel.isReset == true{
            
            appDel.allAnswerNumber = 0
            nextButton.isHidden = true
            nextButtonImage.isHidden = true
            enterButton.isHidden = false
            enterButtonImage.isHidden = false
            //selectQuestionKey = appDel.selectVocaburalyNotebook
            //correctNumber = appDel.correctRate
            
            initquestion()
        }
        //selectQuestionKey = appDel.selectVocaburalyNotebook
        //correctNumber = appDel.correctRate
        //print(selectQuestionKey)
        
        //問題データがなかった時の動作
        if questionList.count == 0{
            initquestion()
        }
        
        //問題を追加した後の動作
        //問題を作った、かつ、解いた問題が0でない時(解いている途中)
        if appDel.isAddVocaburaly == true && appDel.allAnswerNumber != 0{
            //保存されている問題がからじゃないかの確認
            if((UserDefaults.standard.object(forKey: selectQuestionKey)) != nil){
                let lastQuestions: [[String]] = UserDefaults.standard.object(forKey: selectQuestionKey) as! [[String]]
                questionList.append(lastQuestions.last!)
                if questionLabel.text == "" {
                    questionLabel.text = questionList[0][0]
                }
            }
            appDel.isAddVocaburaly = false
            //問題を作った、かつ、解いた問題が0の時(解く前)
        } else if appDel.isAddVocaburaly == true && appDel.allAnswerNumber == 0{
            initquestion()
        }
        
    }
    
    //画面が最初に現れた時のみの動作
    override func viewDidLoad() {
        super.viewDidLoad()
        appDel.allAnswerNumber = 0
        
        inputAnswer.delegate = self
        
        questionLabel.font = UIFont(name: "HOKKORI",size:24)
        answerLabel.font = UIFont(name: "HOKKORI",size:24)
        
        nextButton.isHidden = true
        nextButtonImage.isHidden = true
        enterButton.isHidden = false
        enterButtonImage.isHidden = false
        selectQuestionKey = appDel.selectVocaburalyNotebook
        correctNumber = appDel.correctRate
        
        initquestion()
    }
    
    func initquestion(){
        nowQuestionNumber = 0
        //もしも、問題データがなかったら、"問題を作成する画面"に移動する
        if((UserDefaults.standard.object(forKey: selectQuestionKey)) == nil){
            let delay = 0.5 * Double(NSEC_PER_SEC)
            let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                self.performSegue(withIdentifier: "toMoveVMC", sender: nil)
            })
            //そうでなかったら、問題を初めから始める
        }else{
            questionList = (UserDefaults.standard.object(forKey: selectQuestionKey) as! [[String]])
            if questionList.count == 0{
                self.performSegue(withIdentifier: "toMoveVMC", sender: nil)
                return
            }
            questionLabel.text = questionList[0][0]
            appDel.allQuestionNumber = Double(questionList.count)
        }
    }
    
    
    
    func pushEnterButton(_ sender : UIButton) {
        print("カウントの回数")
        appDel.allAnswerNumber += 1
        answerNumber += 1
        print(nowQuestionNumber)
        
        //問題に答えなかった時の動作
        //        if isAnswer != true {
        
        //もしも、問題データがなかったら、アラートを表示する
        if UserDefaults.standard.object(forKey: selectQuestionKey) == nil{
            let alert: UIAlertController = UIAlertController(title: "", message: "単語が登録されていません。\nADDボタンから単語を登録して下さい。", preferredStyle:  UIAlertControllerStyle.alert)
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            return
            //もしも、問題データがあったら、 pushEnterButtonの動作をする
        }else{
            NSLog("hogeの中身は。。。%@",questionList[nowQuestionNumber][1])
            NSLog("textFieldの中身は。。。%@",inputAnswer.text!)
            
            //答えの部分において、改行部分を削除する
            questionList[nowQuestionNumber][1] = self.removeLineBreak(questionList[nowQuestionNumber][1])
            
            //不正解の問題をもう一度繰り返す
            if questionList.count <= nowQuestionNumber{
                print("nowQuestionNumber = \(nowQuestionNumber)")
                nowQuestionNumber = 0
                
                self.scoreButton.isHidden = false
                
                return
            }
        }
        
        enterButton.isHidden = true
        enterButtonImage.isHidden = true
        
        //問題に正解した時の動作
        if questionList[nowQuestionNumber][1] == inputAnswer.text {
            
            questionList.remove(at: nowQuestionNumber)
            
            correctNumber = correctNumber+1.0
            
            let emptyCheck = questionList.isEmpty
            
            //全ての問題に正解し終わった時の動作
            if  emptyCheck {
                
                if answerNumber == 0{
                    appDel.correctRate = 0
                    
                }else if answerNumber < Int(appDel.allQuestionNumber){
                    
                    appDel.correctRate = (correctNumber/Double(appDel.allAnswerNumber))*100.0
                    
                }else {
                    appDel.correctRate = correctNumber/appDel.allAnswerNumber*100.0
                }
                print(appDel.allAnswerNumber)
                print(correctNumber)
                
                answerLabel.text = ""
                performSegue(withIdentifier: "toMoveSC",sender: nil)
                correctNumber = 0
                
                //self.performSegueWithIdentifier("score", sender: nil)
                inputAnswer.text = ""
                NSLog("正解しました１")
                return
            }
            
            //不正解の問題をもう一度繰り返す
            if questionList.count <= nowQuestionNumber{
                nowQuestionNumber = 0
            }
            
            questionLabel.text = questionList[nowQuestionNumber][0]
            answerLabel.text = ""
            //isAnswer = false
            inputAnswer.text = ""
            NSLog("正解しました２")
            enterButton.isHidden = false
            enterButtonImage.isHidden = false
            
            //問題に不正解した時の動作
        } else {
            answerLabel.text = questionList[nowQuestionNumber][1]
            //isAnswer =  true
            nowQuestionNumber += 1
            inputAnswer.text = ""
            NSLog("不正解です")
            nextButton.isHidden = false
            nextButtonImage.isHidden = false
        }
        
        //問題に答えた時の動作
        //        } else {
        //            questionLabel.text = questionList[nowQuestionNumber][0]
        //            answerLabel.text = ""
        //            inputAnswer.text = ""
        //            isAnswer = false
        //        }
    }
    
    //画面の任意の場所を押した時、キーボードが引っ込む動作
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //改行部分を削除する(Enterを押した時、改行にならないように)
    func removeLineBreak(_ string: String) -> String {
        var stringArray = string.components(separatedBy: "\n")
        return stringArray[0]
    }
    
    //    func textfield(textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //
    //        return true
    //    }
}

// MARK: - textField
extension VocaburalyNotebook: UITextFieldDelegate {
    
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
// MARK: - AVSpeechSynthesizer
extension VocaburalyNotebook {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer!, didStartSpeechUtterance utterance:AVSpeechUtterance!)
    {
        print("***開始***")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer!, didFinishSpeechUtterance utterance: AVSpeechUtterance!)
    {
        print("***終了***")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer!, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance!)
    {
        let word = (utterance.speechString as NSString).substring(with: characterRange)
        print("Speech: \(word)")
    }
    
    @IBAction func voice1(){
        self.speach()
    }
    
    @IBAction func voice2(){
        self.speach2()
    }
    
    func speach() {
        let utterance = AVSpeechUtterance(string:self.questionLabel.text!)
        language = UserDefaults.standard.object(forKey: selectQuestionKey + "langKey") as! String
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
        self.talker.speak(utterance)
    }
    
    func speach2() {
        let utterance = AVSpeechUtterance(string:self.answerLabel.text!)
        language = UserDefaults.standard.object(forKey: selectQuestionKey + "langKey") as! String
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
        self.talker.speak(utterance)
    }
}

// MARK: - pushButton
extension VocaburalyNotebook{
    
    //AddButtonを押した時に遷移する動作
    @IBAction func didTapAddButton() {
        self.performSegue(withIdentifier: "toMoveVMC", sender: nil)
    }
    
    @IBAction func pushAddButton(_ sender : UIButton) {
        performSegue(withIdentifier: "toMoveVMC",sender: nil)
    }
    
    //SccoreButtonを押した時に遷移する動作
    //    @IBAction func didTapScoreButton() {
    //        answerLabel.text = ""
    //        self.performSegueWithIdentifier("toMoveSC", sender: nil)
    //    }
    
    @IBAction func pushScoreButton(){
        
        if answerNumber == 0{
            appDel.correctRate = 0
            
        }else if answerNumber < Int(appDel.allQuestionNumber){
            
            appDel.correctRate = (correctNumber/Double(appDel.allQuestionNumber))*100.0
            
        }else {
            appDel.correctRate = correctNumber/appDel.allQuestionNumber*100.0
            
        }
        answerLabel.text = ""
        performSegue(withIdentifier: "toMoveSC",sender: nil)
    }
    
    @IBAction func pushNextQuestionButton(){
        nextButton.isHidden = true
        nextButtonImage.isHidden = true
        enterButton.isHidden = false
        enterButtonImage.isHidden = false
        
        if questionList.count <= nowQuestionNumber{
            nowQuestionNumber = 0
        }
        questionLabel.text = questionList[nowQuestionNumber][0]
        answerLabel.text = ""
        inputAnswer.text = ""
        //isAnswer = false
    }
    
    @IBAction func pushBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
}

