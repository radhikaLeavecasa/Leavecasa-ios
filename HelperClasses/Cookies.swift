//
//  Cookes.swift
//  Josh
//
//  Created by Esfera-Macmini on 28/04/22.
//

import Foundation

extension NSDictionary {
    
    var emailVerified:Int{
        let emailVerified = self["email_verified"] as? Int ?? 0
        return emailVerified
    }
    
    var name:String{
        let fullName = self["name"] as? String ?? ""
        return fullName
    }
    
    var notification_setting: Int{
        let notification_setting = self["notification_setting"] as? Int ?? 0
        return notification_setting
    }
    
    var title:String{
        let title = self["title"] as? String ?? ""
        return title
    }
    
    var lastName:String{
        let lastName = self["last_name"] as? String ?? ""
        return lastName
    }

    var countryCode:String{
        let countryCode = self["country_code"] as? String ?? ""
        return countryCode
    }
    
    var id:Int{
        let id = self["id"] as? Int ?? 0
        return id
    }
    
    var email:String{
        let email = self["email"] as? String ?? ""
        return email
    }
    
    var mobile:String{
        let mobile = self["mobile"] as? String ?? ""
        return mobile
    }
    
    var gender:String{
        let gender = self["gender"] as? String ?? ""
        return gender
    }
    
    var address:String{
        let address = self["address"] as? String ?? ""
        return address
    }
    
    var nationality:String{
        let nationality = self["nationality"] as? String ?? ""
        return nationality
    }
    
    var marital_status:String{
        let marital_status = self["marital_status"] as? String ?? ""
        return marital_status
    }
    
    var dob:String{
        let dob = self["dob"] as? String ?? ""
        return dob
    }
    
    var path:String{
        let path = self["path"] as? String ?? ""
        return path
    }
    
    var profile_pic:String{
        let profile_pic = self["profile_pic"] as? String ?? ""
        return "\(path)\(profile_pic)"
    }
    
    var city:String{
        let city = self["city"] as? String ?? ""
        return city
    }
}

class Cookies {
    
    class func userInfoSave(dict : [String : Any]? = nil){
        let keyData = NSKeyedArchiver.archivedData(withRootObject: dict as Any)
        UserDefaults.standard.set(keyData, forKey: "userInfoSave")
        UserDefaults.standard.synchronize()
    }
    
    class func userInfo() -> NSDictionary? {
        if let some =  UserDefaults.standard.object(forKey: "userInfoSave") as? NSData {
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: some as Data) as? NSDictionary {
                return dict
            }
        }
        return nil
    }
    
    class func saveUserToken(token: String) {
        UserDefaults.standard.set(token, forKey: CommonParam.DEVICE_TOKEN)
    }
    
    class func saveUserCredit(token: String) {
        UserDefaults.standard.set(token, forKey: "Passes")
    }
    
    class func saveIntro(bool: Bool) {
        UserDefaults.standard.set(bool, forKey: CommonParam.INTRO_DONE)
    }
    
    class func saveDeviceToken(token: String) {
        UserDefaults.standard.set(token, forKey: "deviceToken")
    }
    
    class func saveUserTokenId(tokenId: Int) {
        UserDefaults.standard.set(tokenId, forKey: "UserTokenId")
    }
    
    class func getUserTokenId() -> Int {
        if let token = UserDefaults.standard.value(forKey: "UserTokenId") as? Int {
            return token
        }
        return 0
    }
    
    class func getInto() -> Bool {
        if let intro = UserDefaults.standard.value(forKey: CommonParam.INTRO_DONE) as? Bool {
            return intro
        }
        return false
    }
    
    class func getDeviceToken() -> String {
        if let token = UserDefaults.standard.value(forKey: "deviceToken") as? String {
            return token
        }
        return "123"
    }
    
    class func getUserToken() -> String {
        if let token = UserDefaults.standard.value(forKey: WSResponseParams.WS_RESP_PARAM_ACCESS_TOKEN) as? String {
            return token
        }
        return ""
    }
    
    class func getUserCredit() -> String {
        if let token = UserDefaults.standard.value(forKey: "Passes") as? String {
            return token
        }
        return ""
    }
    
    class func deleteUserInfo() {
        UserDefaults.standard.removeObject(forKey: "userInfoSave")
    }
    
    class func deleteUserToken() {
        UserDefaults.standard.removeObject(forKey: WSResponseParams.WS_RESP_PARAM_ACCESS_TOKEN)
    }
}

var currentAccessToken :String? {
    get {
        return UserDefaults.standard.currentAccessToken()
    }
    set {
        UserDefaults.standard.currentAccessToken(newValue)
    }
}

extension UserDefaults {
    
    /// Private key for persisting the active Theme in UserDefaults
    private static let currentAccessTokenKey = "AuthToken"
    
    /// Retreive theme identifer from UserDefaults
    public func currentAccessToken() -> String? {
        return self.string(forKey: UserDefaults.currentAccessTokenKey)
    }
    
    /// Save theme identifer to UserDefaults
    public func currentAccessToken(_ identifier: String?) {
        self.set(identifier, forKey: UserDefaults.currentAccessTokenKey)
    }
}
