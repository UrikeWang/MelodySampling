//
//  RandomUserManager.swift
//  King of Song Quiz
//
//  Created by Meng Hsien Lin on 2017/12/25.
//  Copyright © 2017年 Marvin Lin. All rights reserved.
//
import UIKit

class RandomUserManager {

    func requestAUser() {
        
        let requestURL = URL(string: "https://randomuser.me/api/")
        
        let task = URLSession.shared.dataTask(with: requestURL!) { (data, response, error) in
            
            var errorCounter = 0
            
            guard let data = data else { return }
            
            do {
                
                let randomUser = try JSONDecoder().decode(RandomUser.self, from: data)
                
                print("===== Below is info =====")
                print(randomUser.info)
                
                print("===== Below is randomUser")
                let results = randomUser.results
                
                let aUser = results[0]
                
                print(aUser)
                print(type(of: aUser))
                
                print(results[0].picture.large)
                print(type(of: results[0].id.value))
                
                let imageURLString = results[0].picture.large
                
                guard let imageURL = URL(string: imageURLString) else { return }
                
                DispatchQueue.global().async {
                    
                    do {
                        
                        let imageData = try Data(contentsOf: imageURL)
                        
                        DispatchQueue.main.async {
                            
                            UserDefaults.standard.setValue(imageData, forKeyPath: "RandomUserImageData")
                            
                            let randomUserName = "\(aUser.login.username)"
                            
                            UserDefaults.standard.setValue(randomUserName, forKeyPath: "RandomUserName")
                        }
                        
                    } catch {
                        print("Error occured during download")
                    }
                }
                
            } catch {
                print("Error occured during JSON decode")
                
                errorCounter += 1
                
                if errorCounter < 4 {
                    self.requestAUser()
                }
            }
        }
        
        task.resume()
    }

}
