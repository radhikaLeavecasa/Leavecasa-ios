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
    
//    func checkForUpdate(completion:@escaping(Bool)->()) {
//        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//        let bundleInfo = Bundle.main.infoDictionary
//        let identifier = bundleInfo?["CFBundleIdentifier"] as? String
//
//        guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier ?? "com.leavecasa.app")") else {
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else { return }
//
//            do {
//                let versionInfo = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                let latestVersion = versionInfo?["version"] as? String
//
//                if latestVersion != currentVersion {
//                    // Prompt user to download the latest version
//                    completion(true)
////                    let alertController = UIAlertController(title: "Update Available", message: "A new version of the app is available. Would you like to download it?", preferredStyle: .alert)
////
////                    alertController.addAction(UIAlertAction(title: "Download", style: .default, handler: { _ in
////                        if let url = URL(string: "http://your-app-download-url") {
////                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
////                        }
////                    }))
////
////                    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
////
////                    DispatchQueue.main.async {
////                        self.present(alertController, animated: true, completion: nil)
////                    }
//                }
//            } catch {
//                completion(false)
//                print("Error parsing JSON: \(error.localizedDescription)")
//            }
//        }.resume()
//    }
    
}
