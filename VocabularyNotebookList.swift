//
//  VocabularyNotebookList.swift
//  WORDLE
//
//  Created by Masanari Miyamoto on 2016/07/27.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit
import SWTableViewCell

class VocabularyNotebookList: UIViewController {
    
    @IBOutlet var vocabularyNotebookTableView : UITableView!
    
    @IBOutlet var editButtonImage : UIImageView!
    
    //Cellの左の余白
    @IBOutlet var leftMargin : NSLayoutConstraint!
    
    //単語帳の名前
    var vocabularyNotebookNameArray : [String] = []
    
    let defaults = UserDefaults.standard
    
    let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //画面が現れる度に起こる動作
    override func viewWillAppear(_ animated: Bool) {
        loadVocabularyNotebook()
    }
    
    func loadVocabularyNotebook(){
        
        //単語帳の情報の取得
        if((defaults.object(forKey: "openKey")) != nil){
            
            let objects = defaults.object(forKey: "openKey") as? [String]
          
            vocabularyNotebookNameArray.removeAll()
            
            for nameString in objects!{
                
                vocabularyNotebookNameArray.append(nameString as String)
            }
            
        }
        
        vocabularyNotebookTableView.reloadData()
    }
    
    //画面が最初に現れた時のみの動作
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TableViewの初期設定
        vocabularyNotebookTableView.dataSource = self
        
        vocabularyNotebookTableView.delegate = self
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.vocabularyNotebookTableView.frame.width, height: self.vocabularyNotebookTableView.frame.height))
        
        let image = UIImage(named: "Startback.png")
        
        imageView.image = image
        
        imageView.alpha = 0.5
        
        self.vocabularyNotebookTableView.backgroundView = imageView
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    //TableViewをスライドで編集モード
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        vocabularyNotebookTableView.isEditing = true
        vocabularyNotebookTableView.setEditing(true, animated: true)
    }
    
    //EditButtonを押した時、編集モードになる
    @IBAction func pushEditButton(){
        //        vocabularyNotebookTableView.editing = true
        //        vocabularyNotebookTableView.setEditing(true, animated: true)
        
        //editButtonImage.image = UIImage(named:"Done.png")
        
        if(vocabularyNotebookTableView.isEditing == true) {
            vocabularyNotebookTableView.isEditing = false
            vocabularyNotebookTableView.setEditing(false, animated: true)
            editButtonImage.image = UIImage(named:"Edit.png")
        } else {
            vocabularyNotebookTableView.isEditing = true
            vocabularyNotebookTableView.setEditing(true, animated: true)
            editButtonImage.image = UIImage(named:"DONE.png")
            
        }
        
        //  leftMargin.constant = -38
    }
    
    
}

// MARK: - TableViewDataSource,TableViewDelegate
extension VocabularyNotebookList: UITableViewDataSource, UITableViewDelegate {
    
    //Cellの数が単語帳(vocabularyNotebookNameArray)の数と同じ
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return vocabularyNotebookNameArray.count
    }
    
    //Cellの何番目に何があるかの把握
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // tableCell の ID で SWTableViewCell のインスタンスを生成
        let cell = vocabularyNotebookTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SWTableViewCell
        // ボタンの設定
        cell.rightUtilityButtons = self.getLeftButtonsToCell() as [AnyObject]
        
        //SWTableViewCellの初期化
        cell.delegate = self
        
        //このCellはindexPath.rowのCellである
        cell.tag = (indexPath as NSIndexPath).row
        
        cell.textLabel?.text = vocabularyNotebookNameArray[(indexPath as NSIndexPath).row]
        
        cell.backgroundColor = UIColor.clear
        
        cell.textLabel?.textAlignment = NSTextAlignment.center
        
        cell.contentView.backgroundColor = UIColor.clear
        
        cell.textLabel?.font = UIFont(name:"HOKKORI",size:24)
        
        return cell
    }
    
    
    //Cellを選択した時の動作
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("%@が選ばれました",vocabularyNotebookNameArray[(indexPath as NSIndexPath).row])
        appDel.selectVocaburalyNotebook = vocabularyNotebookNameArray[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "toMoveVNC",sender: nil)
    }
    
    //TableViewが動作(削除)可能にする
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //並び替えが終わった時の動作
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        
        // array[1] array[sourceIndexPath.row]
        //配列の入れ替え
        let temp = vocabularyNotebookNameArray[(sourceIndexPath as NSIndexPath).row]
        vocabularyNotebookNameArray[(sourceIndexPath as NSIndexPath).row] = vocabularyNotebookNameArray[(destinationIndexPath as NSIndexPath).row]
        vocabularyNotebookNameArray[(destinationIndexPath as NSIndexPath).row] = temp
        vocabularyNotebookTableView.reloadData()
        
        UserDefaults.standard.set(self.vocabularyNotebookNameArray, forKey:"openKey");
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
extension VocabularyNotebookList: SWTableViewCellDelegate{
    
    //右からのスワイプ時のボタンの設定
    func getLeftButtonsToCell()-> NSMutableArray{
        let utilityButtons: NSMutableArray = NSMutableArray()
        utilityButtons.sw_addUtilityButton(with: UIColor(red: 159/255, green: 159/255, blue: 159/255, alpha: 1), icon: UIImage(named:"Edit2"))
        utilityButtons.sw_addUtilityButton(with: UIColor(red: 201/255, green: 82/255, blue: 68/255, alpha: 1), icon: UIImage(named:"Delete"))
        return utilityButtons
    }
    
    // 右からのスワイプ時のボタンのアクション
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        switch index {
        case 0:appDel.selectVocaburalyNotebook = vocabularyNotebookNameArray[cell.tag]
            performSegue(withIdentifier: "toMoveVCC",sender: nil)
        
        case 1:
            let alert: UIAlertController = UIAlertController(title: "削除します", message: "本当に削除しても良いですか？", preferredStyle:  UIAlertControllerStyle.alert)
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                (action: UIAlertAction!) -> Void in
                print("OK")
                print(cell.tag)
                UserDefaults.standard.removeObject(forKey: self.vocabularyNotebookNameArray[cell.tag])
                self.vocabularyNotebookNameArray.remove(at: cell.tag)
                
                self.vocabularyNotebookTableView.deleteRows(at: [IndexPath(row: cell.tag, section: 0)],
                    with: UITableViewRowAnimation.fade)
                
                self.vocabularyNotebookTableView.reloadData()
                
                UserDefaults.standard.set(self.vocabularyNotebookNameArray, forKey:"openKey");
                UserDefaults.standard.synchronize()
            })
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                (action: UIAlertAction!) -> Void in
                print("Cancel")
                
                self.vocabularyNotebookTableView.isEditing = false
            })
            
            alert.addAction(defaultAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
}
