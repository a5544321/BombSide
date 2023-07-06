//
//  NetworkAction.swift
//  BombSide
//
//  Created by Andy on 2018/11/2.
//  Copyright © 2018年 com.andy. All rights reserved.
//

import Foundation

typealias responseCallback = (_ response :[String : Any]?, _ error:  Error?) -> ()

class NetworkAction {
    
    static func searchPlace(url: URL, handler:  @escaping responseCallback){
         let session = URLSession.shared
       
        let task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode else{
                    handler(nil, error)
                    return
                }
                guard let data = data else {
                    handler(nil, error)
                    return
                }
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else{
                    handler(nil, error)
                    return
                }
                    
                guard let finalJson = jsonData as? [String : Any] else{
                    handler(nil, error)
                    return
                }
                
                handler(finalJson, nil)
            }
        }
        
        task.resume()
       
    }
    func rrrrr(count: Int, action: (Int)->()) {
        let i = 0
        
        guard var ii = i as? Float else{
            return
        }
        
        ii += 1
    }
    func nonono()  {
        rrrrr(count: 3) { (intt) in
            
        }
    }
    
}
