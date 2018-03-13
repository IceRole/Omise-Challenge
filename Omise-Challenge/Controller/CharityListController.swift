//
//  CharityListController.swift
//  Omise-Challenge
//
//  Created by Shivam on 13/03/18.
//  Copyright © 2018 Omise. All rights reserved.
//

import UIKit

class CharityListController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var charityList:Array<Any>!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        if charityList.count as! Int != nil {
            return charityList.count ;

        } else {
            return 0;
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "charityCell", for: indexPath) as! CharityCellView
        if let charityData = charityList?[indexPath.row] as? NSDictionary {
            
            cell.charityName.text = charityData["name"] as? String
//            if ((charityData.value(forKey: "image") as? String) != nil){
//
//            }
        print(charityData)
        }
        return cell
    }
    

    @IBOutlet weak var charityTable: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
 ApiDataSource.sharedInstance.getCharityList(completion: {
    result in
    print(result);
    
    self.charityList = result ;
    self.charityTable.reloadData()
 })
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
