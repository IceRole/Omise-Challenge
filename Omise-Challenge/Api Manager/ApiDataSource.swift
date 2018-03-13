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
        
        sendRequestToServerWithUrl(apiName: "charities", method: "GET", completion:{result in
            
            completion(result)

        })
    }

    
    //MARK: REQUEST HANDLER

    func sendRequestToServerWithUrl(apiName:String, method:String, completion: @escaping (_ result: Array<Any>) -> Void){
        
        var request = URLRequest(url: URL(string:ApiDataSource.BASE_URL + "/" + apiName)!)

        request.httpMethod = method
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: request) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            
            // ERROR CODE CHECK
            let status = (response as! HTTPURLResponse).statusCode
            if status != 200{
                print(status)
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
   

    

}
