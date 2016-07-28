//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(completion: (NSArray) -> ()) {
        let url = NSURL(string: api_URL)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        }
        task.resume()
    }
    
    
    class func checkIfRepositoryIsStarred(fullName: String, completion:(Bool) -> ()) {
        let urlString = "\(Secrets.githubStarredAPIURL)/\(fullName)"
        
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "GET"
        request.addValue("\(Secrets.git_personal_access_token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("Hey HTTP request didn't work")
                return
            }
            if responseValue.statusCode == 204 {
                completion(true)
            }else if responseValue.statusCode == 404 {
                completion(false)
            }else {
                print("Other status code \(responseValue.statusCode) ")
            }
        }
        task.resume()
    }
    
    
    class func starRepository(fullName: String, completion: () -> ()) {
        let urlString = "\(Secrets.githubStarredAPIURL)/\(fullName)"
        
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "PUT"
        request.addValue("\(Secrets.git_personal_access_token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("Hey HTTP request didn't work")
                return
            }
            if responseValue.statusCode == 204 {  //I could now write 200...300 we're good irl
                
                print("You just starred \(fullName.uppercaseString)")
                completion()
            }else {
                print("Couldn't star repo \(responseValue.statusCode) ")
            }
        }
        task.resume()
    }
    
    class func unStarRepository(fullName: String, completion: () -> ()) {
        let urlString = "\(Secrets.githubStarredAPIURL)/\(fullName)"
        
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        
        let request = NSMutableURLRequest(URL: unwrappedURL)
        request.HTTPMethod = "DELETE"
        request.addValue("\(Secrets.git_personal_access_token)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let responseValue = response as? NSHTTPURLResponse else {
                assertionFailure("Hey HTTP request didn't work")
                return
            }
            if responseValue.statusCode == 204 {  //200...300 we're good
                print("You just unstarred \(fullName.uppercaseString)")
                completion()
            }else {
                print("Couldn't unstar repo \(responseValue.statusCode) ")
            }
        }
        task.resume()
    }

}

