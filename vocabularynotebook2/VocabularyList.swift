//
//  VocabularyList.swift
//  vocabularynotebook2
//
//  Created by Masanari Miyamoto on 2016/07/28.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit
import SWTableViewCell

class VocabularyList: UIViewController {
    
    @IBOutlet var vocabularyTableView : UITableView!
    
    @IBOutlet var editButtonImage : UIImageView!
    
    //単語の名前
    var vocabularyNameArray : [[String]] = []
    
    let defaults = UserDefaults.standard
    
    //NSUserDefaultsにおいて、選択した問題を把握するための鍵
    var selectQuestionKey: String = ""
    
    //AppDelegate.swiftで宣言した変数を使用
    let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //画面が現れる度に起こる動作
    override func viewWillAppear(_ animated: Bool) {
        selectQuestionKey = appDel.selectVocaburalyNotebook
        loadVocabulary()
    }
    
    func loadVocabulary(){
        
        //単語帳の情報の取得
        if((defaults.object(forKey: selectQuestionKey)) != nil){
            
            let objects = defaults.object(forKey: selectQuestionKey) as? [[String]]
            
            
            //  var nameString:AnyObject
            
            vocabularyNameArray.removeAll()
            
            for nameString in objects!{
                
                vocabularyNameArray.append(nameString as [String])
            }
            
        }
        vocabularyTableView.reloadData()
    }
    
    //画面が最初に現れた時のみの動作
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableViewの初期設定
        vocabularyTableView.dataSource = self
        
        vocabularyTableView.delegate = self
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.vocabularyTableView.frame.width, height: self.vocabularyTableView.frame.height))
        
        let image = UIImage(named: "Startback.png")
        
        imageView.image = image
        
        imageView.alpha = 0.5
        
        self.vocabularyTableView.backgroundView = imageView
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    //TableViewをスライドで編集モード
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        vocabularyTableView.isEditing = true
        vocabularyTableView.setEditing(true, animated: true)
    }
    
    //EditButtonを押した時、編集モードになる
    @IBAction func pushEditButton(){
        
        if(vocabularyTableView.isEditing == true) {
            vocabularyTableView.isEditing = false
            vocabularyTableView.setEditing(false, animated: true)
            editButtonImage.image = UIImage(named:"Edit.png")
        } else {
            vocabularyTableView.isEditing = true
            vocabularyTableView.setEditing(true, animated: true)
            editButtonImage.image = UIImage(named:"DONE.png")
            
        }
        
        //  leftMargin.constant = -38
    }
}

// MARK: - TableViewDataSource,TableViewDelegate
extension VocabularyList: UITableViewDataSource, UITableViewDelegate{
    //Cellの数が単語帳(vocabularyNotebookNameArray)の数と同じ
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return vocabularyNameArray.count
    }
    
    //Cellの何番目に何があるかの把握
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // tableCell の ID で SWTableViewCell のインスタンスを生成
        let cell = vocabularyTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SWTableViewCell
        //tagがCellのと被らないように
        let questionLabel: UILabel = cell.viewWithTag(1000) as! UILabel
        let answerLabel: UILabel = cell.viewWithTag(1001) as! UILabel

        questionLabel.text = vocabularyNameArray[(indexPath as NSIndexPath).row][0]
        answerLabel.text = vocabularyNameArray[(indexPath as NSIndexPath).row][1]

        // ボタンの設定
        cell.rightUtilityButtons = self.getLeftButtonsToCell() as [AnyObject]
        
        //SWTableViewCellの初期化
        cell.delegate = self
        
        //このCellはindexPath.rowのCellである
        cell.tag = (indexPath as NSIndexPath).row
        
        cell.backgroundColor = UIColor.clear
        
        cell.textLabel?.textAlignment = NSTextAlignment.center
        
        cell.contentView.backgroundColor = UIColor.clear
        
        cell.textLabel?.font = UIFont(name:"HOKKORI",size:24)
        
        return cell
    }
    
    //TableViewが動作(削除)可能にする
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //並び替えが終わった時の動作
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        
        // array[1] array[sourceIndexPath.row]
        //配列の入れ替え
        let temp = vocabularyNameArray[(sourceIndexPath as NSIndexPath).row]
        vocabularyNameArray[(sourceIndexPath as NSIndexPath).row] = vocabularyNameArray[(destinationIndexPath as NSIndexPath).row]
        vocabularyNameArray[(destinationIndexPath as NSIndexPath).row] = temp
      //  vocabularyTableView.reloadData()
        
        UserDefaults.standard.set(self.vocabularyNameArray, forKey:selectQuestionKey);
        UserDefaults.standard.synchronize()
    }
    
    //削除機能ボタンを削除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    //削除機能ボタン登場時のズレを削除
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

// MARK: - pushButton
extension VocabularyList: SWTableViewCellDelegate{
    
    //右からのスワイプ時のボタンの設定
    func getLeftButtonsToCell()-> NSMutableArray{
        let utilityButtons: NSMutableArray = NSMutableArray()
        utilityButtons.sw_addUtilityButton(with: UIColor(red: 201/255, green: 82/255, blue: 68/255, alpha: 1), icon: UIImage(named:"Delete-1"))
        return utilityButtons
    }
    
    // 右からのスワイプ時のボタンのアクション
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        switch index {
        case 0:
            let alert: UIAlertController = UIAlertController(title: "削除します", message: "本当に削除しても良いですか？", preferredStyle:  UIAlertControllerStyle.alert)
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
                print(cell.tag)
                UserDefaults.standard.removeObject(forKey: self.vocabularyNameArray[cell.tag][0])
                self.vocabularyNameArray.remove(at: cell.tag)
                
                self.vocabularyTableView.reloadData()
                
                UserDefaults.standard.set(self.vocabularyNameArray, forKey:self.selectQuestionKey);
                UserDefaults.standard.synchronize()
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
                
                self.vocabularyTableView.isEditing = false
            })
            
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    
    
    @IBAction func pushBackButton(){
        self.dismiss(animated: true, completion: nil)
    }
}
