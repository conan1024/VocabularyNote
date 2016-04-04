//
//  ItirannViewController.swift
//  vocabularynotebook2
//
//  Created by Masanari Miyamoto on 2016/02/20.
//  Copyright © 2016年 Masanari Miyamoto. All rights reserved.
//

import UIKit

class ItirannViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var table : UITableView!
    
    var vocablaryNameArray = [String]()
    
    //空の配列を用意する
    var stringArray : [String] = []
    
    //中身を確認するためのnum
    var num = 0
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        table.dataSource = self
        
        table.delegate = self
        
        //        table.reloadData()
        //        yomikomi()
        
        //        vocablaryNameArray = ["英語","数学","国語"]
        
        // make UIImageView instance
        let imageView = UIImageView(frame: CGRectMake(0, 0, self.table.frame.width, self.table.frame.height))
        // read image
        let image = UIImage(named: "Startback.png")
        // set image to ImageView
        imageView.image = image
        // set alpha value of imageView
        imageView.alpha = 0.5
        // set imageView to backgroundView of TableView
        self.table.backgroundView = imageView
        
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        yomikomi()
    }
    
    func yomikomi(){
        //読み込み　tableviewに入れてあげる
        
        //昔"openKey"という鍵で保存したかどうか確認
        if((defaults.objectForKey("openKey")) != nil){
            
            //objectsを配列として確定させ、前回の保存内容を格納
            let objects = defaults.objectForKey("openKey") as? [String]
            
            //各名前を格納するための変数を宣言
            var nameString:AnyObject
            
            //※ちゃんとリフレッシュすることが大事////////////////
            stringArray.removeAll()
            
            //前回の保存内容が格納された配列の中身を一つずつ取り出す
            for nameString in objects!{
                //配列に追加していく
                stringArray.append(nameString as String)
            }
            
        }
        
        table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return stringArray.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = stringArray[indexPath.row]
        //cell.imageView?.image = UIImage(named:"cell画像.png")
        cell.backgroundColor = UIColor.clearColor()
        //cell.contentView.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        cell.textLabel?.font = UIFont(name:"HOKKORI",size:24)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("%@が選ばれました",stringArray[indexPath.row])
        appDel.selectedCellText = stringArray[indexPath.row]
        performSegueWithIdentifier("toSubViewController",sender: nil)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.editing = editing
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    /* func tableView(tableView: UITableView, commitEditingStyle editingStyle:
    let alert: UIAlertController = UIAlertController(title: "削除しますか", message: "本当に削除しても良いですか？", preferredStyle:  UIAlertControllerStyle.Alert)
    
    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
    (action: UIAlertAction!) -> Void in
    print("OK")
    })
    let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler:{
    (action: UIAlertAction!) -> Void in
    print("Cancel")
    })*/
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert: UIAlertController = UIAlertController(title: "削除しますか", message: "本当に削除しても良いですか？", preferredStyle:  UIAlertControllerStyle.Alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:{
            (action: UIAlertAction!) -> Void in
            print("OK")
            NSUserDefaults.standardUserDefaults().removeObjectForKey(self.stringArray[indexPath.row])
            // 先にデータを更新する
            self.stringArray.removeAtIndex(indexPath.row)
            
            // それからテーブルの更新
            tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
                withRowAnimation: UITableViewRowAnimation.Fade)
            
            NSUserDefaults.standardUserDefaults().setObject(self.stringArray, forKey:"openKey");
            NSUserDefaults.standardUserDefaults().synchronize();
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.Cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            
            tableView.editing = false
        })
        
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "toSubViewController") {
    let subVC: ViewController = (segue.destinationViewController as? ViewController)!
    // SubViewController のselectedImgに選択された画像を設定する
    subVC.selectedText =  selectedCellText
    }
    }*/
}

