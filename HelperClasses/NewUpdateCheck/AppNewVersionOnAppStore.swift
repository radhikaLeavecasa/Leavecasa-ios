//
//  AppNewVersionOnAppStore.swift
//  LeaveCasa
//
//  Created by acme on 14/02/23.
//

import Foundation
import Alamofire

class VersionCheck {
    
    public static let shared = VersionCheck()
    
    func checkForUpdate(completion:@escaping(Bool)->()){
        let bundleInfo = Bundle.main.infoDictionary
        let identifier = bundleInfo?["CFBundleIdentifier"] as? String
        let currentVersion =
            Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        if let appStoreURL = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier ?? "com.leavecasa.app")") {
            let task = URLSession.shared.dataTask(with: appStoreURL) { (data, response, error) in
                if let error = error {
                    completion(false)
                    return
                }
                if let data = data {
                    do {
                        let versionInfo = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let results = versionInfo?["results"] as? [[String: Any]] {
                            if let firstResult = results.first {
                                if let versionKey = firstResult.first(where: { $0.key == "version" }) {
                                    let latestVersion = versionKey.value
                                    if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
                                        if currentVersion < latestVersion as! String {
                                            completion(true)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    } catch {
                        completion(false)
                    }
                }
            }
            task.resume()
        }
    }
}
