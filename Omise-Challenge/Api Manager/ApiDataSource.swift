//
//  ApiDataSource.swift
//  Omise-Challenge
//
//  Created by Shivam on 13/03/18.
//  Copyright © 2018 Omise. All rights reserved.
//

import UIKit

class ApiDataSource: NSObject {
    
    static var BASE_URL = "http://localhost:8080"
    var data: NSMutableData = NSMutableData()
    
    
    static let sharedInstance: ApiDataSource = {
        let instance = ApiDataSource()
        // setup code
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    
    func getCharityList( completion: @escaping (_ result: Array<Any>) -> Void) {
        let json: [String: Any] = [:];
        
        sendRequestToServerWithUrl(apiName: "charities", jsonBody:json, method: "GET", completion:{result in
            
            completion(result)

        })
    }
    
    func submitDonationDetails(_ name: String, token: String, amount: Int ,completion: @escaping (_ result: String) -> Void) {
        
        let json: [String: Any] = ["name": name,
                                   "token":token,
                                   "amount":amount];
        
        sendPostRequestToServerWithUrl(apiName: "donations", jsonBody: json, method: "POST", completion:{result in
            
            completion(result)
            
        })
    }

    
    //MARK: REQUEST HANDLER

    func sendRequestToServerWithUrl(apiName:String, jsonBody:[String:Any], method:String, completion: @escaping (_ result: Array<Any>) -> Void){
        
        var request = URLRequest(url: URL(string:ApiDataSource.BASE_URL + "/" + apiName)!)

        request.httpMethod = method
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        if (!jsonBody.isEmpty){
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody);
            
            request.httpBody = jsonData

        }
        
        // make the request
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(error?.localizedDescription ?? "Check Network" )
                
                DispatchQueue.main.async {
                // ERROR CODE CHECK
                let alert = UIAlertController(title: "Error", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show alert
                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.windowLevel = UIWindowLevelAlert + 1;
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                };
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            
            
            

            // parse the result as JSON, since that's what the API provides
            do {
                
                let jsonObject : Any =
                    try JSONSerialization.jsonObject(with: responseData, options: [])
                
                print(jsonObject)
                
                
                completion(jsonObject as! Array)
            
            } catch  {
                print("Error trying to convert data to JSON")
                return
            }
        }
        task.resume()

    }
    
    
    
    //MARK: REQUEST POST HANDLER
    
    func sendPostRequestToServerWithUrl(apiName:String, jsonBody:[String:Any], method:String, completion: @escaping (_ result: String) -> Void){
        
        var request = URLRequest(url: URL(string:ApiDataSource.BASE_URL + "/" + apiName)!)
        
        request.httpMethod = method
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        if (!jsonBody.isEmpty){
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonBody);
            
            request.httpBody = jsonData
            
        }
        
        // make the request
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(error?.localizedDescription ?? "Check Network" )
                
                DispatchQueue.main.async {
                    // ERROR CODE CHECK
                    let alert = UIAlertController(title: "Error", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show alert
                    let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                    alertWindow.rootViewController = UIViewController()
                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                    alertWindow.makeKeyAndVisible()
                    alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
                };
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            
            
            
            
            // parse the result as JSON, since that's what the API provides
            do {
                
                let jsonObject : Any =
                    try JSONSerialization.jsonObject(with: responseData, options: [])
                
                print(jsonObject)
                
                
                completion("Data Submitted")
                
            } catch  {
                completion("Data Submitted")
                return
            }
        }
        task.resume()
        
    }
    
   

    

}
