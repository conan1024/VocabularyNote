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
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("%@が選ばれました",stringArray[indexPath.row])
        appDel.selectedCellText = stringArray[indexPath.row]
        performSegueWithIdentifier("toSubViewController",sender: nil)
    }
    
/*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toSubViewController") {
            let subVC: ViewController = (segue.destinationViewController as? ViewController)!
            // SubViewController のselectedImgに選択された画像を設定する
            subVC.selectedText =  selectedCellText
        }
    }*/
}

