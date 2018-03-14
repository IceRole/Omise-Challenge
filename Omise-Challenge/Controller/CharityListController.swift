//
//  CharityListController.swift
//  Omise-Challenge
//
//  Created by Shivam on 13/03/18.
//  Copyright © 2018 Omise. All rights reserved.
//

import UIKit

class CharityListController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var charityList:Array<Any> = []
    var charityName:String = ""

  

    @IBOutlet weak var charityTable: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Seperator line remove
        self.charityTable.separatorStyle = UITableViewCellSeparatorStyle.none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Activity Trigger
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.gray
        self.view.addSubview(actInd)
        actInd.startAnimating()
        
        //API Call
ApiDataSource.sharedInstance.getCharityList(completion: {
            result in
            self.charityList = result ;
            DispatchQueue.main.async {
                self.charityTable.reloadData()
                actInd.stopAnimating()
                actInd.removeFromSuperview()

            };
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: TABLE VIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return charityList.count ;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "charityCell", for: indexPath) as! CharityCellView
        if let charityData = charityList[indexPath.row] as? NSDictionary {
            
            //Charity name
            cell.charityName.text = charityData["name"] as? String
            if ((charityData.value(forKey: "logo_url") as? String) != nil){
                
                //set placeholder image first.
                cell.charityImage.image = UIImage(named: "launchImg")
                cell.charityImage.downloadImageFrom(link: (charityData.value(forKey: "logo_url") as? String)!, contentMode: .scaleAspectFit)
            }
        }
        return cell
    }
    
    //MARK: TABLE VIEW DELEGATE

    func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath){
        if let charityData = charityList[indexPath.row] as? NSDictionary {
            
            charityName =  (charityData["name"] as? String)!
            
            performSegue(withIdentifier: "showDonation", sender: self)

        }
    }
    
    //MARK: SEQUE DELEGATE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DonationViewController
        {
            let vc = segue.destination as? DonationViewController
            vc?.charityName = charityName
        }
    }


}
