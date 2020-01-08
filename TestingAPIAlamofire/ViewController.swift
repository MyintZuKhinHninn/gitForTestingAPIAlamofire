//
//  ViewController.swift
//  TestingAPIAlamofire
//
//  Created by khinhninmyintzu on 5/13/19.
//  Copyright © 2019 khinhninmyintzu. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    private var selectedIndex : Int?
    
    @IBOutlet weak var ratetableView: UITableView!
    
    static let info = "info"
    static let cbdescription = "description"
    static let timestamp = "timestamp"
    static let rate = "rates"
    
    let cbOperation = CBDBOperation()
    let rateOperation = RateDBOperation()
    
    //var objectArray : [CurrencyObject] = []
    var rateArray : [RateClass] = []
    var cbArray : [CentralBankClass] = []
    
    var cbresult = CentralBankClass()
    var infolist = CentralBankInfoList()
    var ratelist = RateList()
    
    var rate = RateClass()
    override func viewDidLoad() {
    super.viewDidLoad()
        
        Alamofire.request("https://forex.cbm.gov.mm/api/latest").responseJSON { (responseData) in
            
            if let JSON = responseData.result.value{
                let resultObject = JSON as! [String : AnyObject]
                
                //ForCentralBankInfo
                let getinfo : AnyObject = resultObject["info"]!
                let getdescription : AnyObject = resultObject["description"]!
                let gettimestamp : AnyObject = resultObject["timestamp"]!
                
                let formattimestamp = gettimestamp as? String ?? "TimeStamp"
                let timestamp = Int(formattimestamp)
                
                self.cbresult?.info = getinfo as? String
                self.cbresult?.description = getdescription as? String
                self.cbresult?.timestamp = timestamp
                
               
            
                self.cbOperation.insertCentralBankInfo(self.cbresult!)
               // self.infolist = self.cbOperation.getAllInfo()
                self.cbresult = self.cbOperation.getAllInfo()
                //self.cbArray = self.infolist!.cblist!
                //let cbObj : Dictionary = (resultObject as? Dictionary<String, AnyObject>)!
               
//                self.cbArray.append(cbObj)
//                self.cbOperation.insertCentralBankInfo(cbObj)
                //self.infolist = self.cbOperation.getAllInfo()
                
                //ForRate
               // let resultObject = JSON as! [String : AnyObject]
                //print("resutl object is \(resultObject)")
                let rateObj : Dictionary = (resultObject[ViewController.rate] as? Dictionary<String, AnyObject>)!
                print(rateObj)
                print(self.infolist?.cblist?.count)
                print(self.cbresult?.id)
                    for (key, value) in rateObj {
                        self.rateArray.append((RateClass(currency: key, rate: value, idx: self.cbresult?.id  ?? 0)))
                    }
            }
        self.ratetableView.reloadData()
        print(self.rateArray.count)
        let rateArrayList = self.rateArray
           let rateObj = RateClass()
        do {
            for object in rateArrayList {
                rateObj?.currency = object.currency
                rateObj?.rate = object.rate
                rateObj?.cbid = object.cbid
                self.rateOperation.insertRate(rateObj!)
            }
        }
        self.ratelist?.ratelist = self.rateArray
        }

        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.ratetableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.rateArray != nil && (self.rateArray.count)>0){
            return (self.rateArray.count)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as? CustomTableViewCell
        //let ratevalue = arrRate[indexPath.row]
        let name = rateArray[indexPath.row].currency
        let value = rateArray[indexPath.row].rate
        cell?.ratelbl.text = name
        cell?.rateValue.text = value as! String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        selectedIndex = indexPath.row
        //print(hlist)
        let rate = ratelist?.ratelist![indexPath.row]
        print(selectedIndex)
        let editButton = UITableViewRowAction(style: .normal, title: "Edit"){
            (action,indexPath)in print("Update")
            //self.updateAction(hero: heros!, indexpath: indexPath)
            
        }
        editButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "Delete"){
            (action,indexPath)in print("delete")
//            deleteAction(hero: <#T##<<error type>>#>, indexpath: <#T##IndexPath#>)
            //self.deleteAction(hero: heros!, indexpath: indexPath)
            
            
        }
        deleteButton.backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        
        return [deleteButton,editButton]
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
//    func deleteAction(rate  : RateClass, indexpath : IndexPath){
//        let showalert = UIAlertController(title: "Confirmation", message: "Are you sure to delete this row?", preferredStyle: .alert)
//        let currentRate = self.ratelist?.ratelist![selectedIndex ?? 0]
//        let confirmAction = UIAlertAction(title: "Yes", style: .default){
//            (action) in self.rateOperation.deleteRate(c, <#T##rate: RateClass##RateClass#>)
//            self.ratetableView.reloadData()
//        }
//
//        let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
//        showalert.addAction(confirmAction)
//        showalert.addAction(cancelAction)
//        present(showalert,animated: true)
//        self.reloadHeroData()
//    }
}

