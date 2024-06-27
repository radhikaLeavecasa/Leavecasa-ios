//
//  ApiCall.swift
//  Josh
//
//  Created by Esfera-Macmini on 25/04/22.
//

import UIKit
import Alamofire
import ObjectMapper
import SearchTextField
import UniformTypeIdentifiers

typealias CompletionBlock = (Bool,String,Any) -> Void
typealias FailureBlock = ([String : Any]) -> Void
typealias ProgressBlock = (Double) -> Void
typealias ErrorHandeling = (Bool,String) -> Void

@objc protocol ResponseProtocol {
    func onSuccess()
    @objc optional func onFail(msg:String)
    @objc optional func onFlightReload()
    @objc optional func apiReload()
    @objc optional func onSuccessDebitWallet()
}

protocol HotelListData {
    func getData(data:[Results], rate: [Int], maxPrice: Double, minPrice: Double, refundable: String, breakfast: String, amenities: [String],propertyType: [String])
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

struct JSONArrayEncoding: ParameterEncoding {
    
    private let array: [Parameters]
    
    init(array: [Parameters]) {
        self.array = array
    }
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        let data = try JSONSerialization.data(withJSONObject: array, options: [])
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        urlRequest.httpBody = data
        
        return urlRequest
    }
}

struct WebService{
    
    static func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    static func callApi(api:Api,method:HTTPMethod = .post,param:[String:Any],encoding:ParameterEncoding = URLEncoding.default,header:Bool = false,completion:@escaping(CompletionBlock)){
        
        if self.isConnectedToInternet(){
            
            let urlString = api.baseURl()
            debugPrint("******URL*****\(urlString) *****Parameters*****\(param)")
            
            var headers = HTTPHeaders()
            
            if header == true {
                headers["Authorization"] = "Bearer \(GetData.share.getUserToken())"
            }
            
            AF.request(urlString, method: method, parameters: param, encoding: encoding, headers: headers,requestModifier: {($0.timeoutInterval = 120 )}).responseData { response in
                debugPrint(urlString)
                switch response.result {
                case .success(let data):
                    do {
                        if let asJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            //let JSON = asJSON as? [String:Any] ?? [:]

                                if isSuccess(json: asJSON) {
                                    debugPrint(asJSON)
                                    if let result = asJSON[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [String:Any]  {
                                        if let error = result[WSResponseParams.WS_RESP_PARAM_ERRORS] as? [[String:Any]]  {
                                            if let msgs = error.first?[WSResponseParams.WS_RESP_PARAM_MESSAGES] as? [String]  {
                                                if let msg = msgs.first{
                                                    completion(false,msg,[:])
                                                }
                                            }
                                        }
                                        else {
                                            let msg = asJSON[CommonParam.MESSAGE] as? String  ?? ""
                                            debugPrint(msg)
                                            completion(true,msg,asJSON)
                                        }
                                    } else {
                                        let msg = asJSON[CommonParam.MESSAGE] as? String  ?? ""
                                        debugPrint(msg)
                                        completion(true,msg,asJSON)
                                    }
                                }
                            else if asJSON.isEmpty == true {
                                //let JSON = asJSON as? [[String:Any]] ?? []
                                completion(true,"",asJSON)
                            }
                                else if let error = asJSON[WSResponseParams.WS_RESP_PARAM_ERRORS] as? [[String:Any]]  {
                                    if let msgs = error.first?[WSResponseParams.WS_RESP_PARAM_MESSAGES] as? [String]  {
                                        if let msg = msgs.first {
                                            completion(false,msg,[:])
                                        }
                                    }
                                }
                                else {
                                    if let msg = asJSON[CommonParam.MESSAGE] as? String {
                                        debugPrint(msg)
                                        completion(false,msg, [:])
                                    }
                                    else {
                                        let result = asJSON[WSResponseParams.WS_RESP_PARAM_RESULTS] as? [[String:Any]] ?? []
                                        let msg = result.first?[WSResponseParams.WS_RESP_PARAM_MESSAGES] as? [String] ?? []
                                        
                                        let response = asJSON["response"] as? [String:Any]
                                        let response1 = response?["Response"] as? [String:Any]
                                        let error = response1?["Error"] as? [String:Any]
                                        let errorMsg = error?["ErrorMessage"] as? String
                                        
                                        if msg.first ?? "" == "" {
                                            if errorMsg != "" && errorMsg != nil {
                                                completion(false,errorMsg ?? "", [:])
                                            } else if let data = asJSON[WSResponseParams.WS_REPS_PARAM_DATA] as? String {
                                                completion(false,data, [:])
                                            } else {
                                                completion(false,CommonError.SOMETHING_WENT_WRONG, [:])
                                            }
                                        } else {
                                            completion(false,msg.first ?? CommonError.SOMETHING_WENT_WRONG, [:])
                                        }
                                    }
                                }
                            //}
                        } else {
                            if let asJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                            //    let JSON = asJSON as? [[String: Any]] ?? [[:]]
                                if asJSON.isEmpty != true {
                                  //  let JSON = asJSON as? [[String:Any]] ?? []
                                    completion(true,"",asJSON)
                                }
                            }
                        }
                        // }
                    } catch  {
                        completion(false,CommonError.SOMETHING_WENT_WRONG,[:])
                    }
                case .failure(let error):
                    completion(false,error.localizedDescription,[:])
                }
            }
        }else{
            completion(false,CommonError.INTERNET,[:])
        }
    }
    
    static func callApi(api:Api,media: UIImage,fileName: String,method:HTTPMethod = .post,param:[String:Any],encoding:ParameterEncoding = URLEncoding.default,completion:@escaping(CompletionBlock)){
        if self.isConnectedToInternet(){
            
            let urlString = api.baseURl()
            debugPrint("******URL*****\(urlString) *****Parameters*****\(param)")
            
            var headers = HTTPHeaders()
            
            headers["Authorization"] = "Bearer \(GetData.share.getUserToken())"
            
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(media.jpegData(
                        compressionQuality: 0.5)!,
                                             withName: fileName,
                                             fileName: "\(fileName).jpg", mimeType: "image/jpg"
                    )
                    for (key, value) in param {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                    }
                },
                to: urlString,
                method: .post ,
                headers: headers
            )
            .responseJSON { response in
                debugPrint(response)
                switch response.result {
                case .success(let value):
                    if let responseValue = value as? [String: AnyObject] {
                        if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String, message == Strings.SUCCESSFULLY_UPLOAD_PROFILE_PIC {
                            completion(true, "\(message)", [:])
                        }
                    } else {
                        completion(false,response.error?.localizedDescription ?? "",[:])
                    }
                case .failure(let error):
                    completion(false, error.localizedDescription,[:])
                }
            }
        }else{
            completion(false,CommonError.INTERNET,[:])
        }
    }
    
    static func uploadFileWithURL(api: Api, files: [String: Data], parameters: [String: Any], header: Bool = false, completion: @escaping (CompletionBlock)) {
        let urlString = api.baseURl()
        debugPrint("******URL*****\(urlString) *****Parameters*****\(parameters)")
        
        var headers = HTTPHeaders()
        
        if header {
            headers["Authorization"] = "Bearer \(GetData.share.getUserToken())"
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            for (fileName, fileData) in files {
                let mimeType: String
                var fileExtension = ""
                
                if let fileNameURL = URL(string: fileName) {
                    let pathExtension = fileNameURL.pathExtension
                    
                    if let uti = UTType(filenameExtension: pathExtension) {
                        mimeType = uti.preferredMIMEType ?? "application/octet-stream"
                        fileExtension = uti.preferredFilenameExtension ?? ""
                    } else {
                        mimeType = "application/octet-stream"
                    }
                } else {
                    mimeType = "application/octet-stream"
                }
                
                multipartFormData.append(fileData, withName: fileName, fileName: "\(fileName).\(fileExtension)", mimeType: mimeType)
            }
            
            for (key, value) in parameters {
                if let stringValue = value as? String {
                    multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                } else if let dataValue = "\(value)".data(using: .utf8) {
                    multipartFormData.append(dataValue, withName: key)
                }
                // Add more types as needed (e.g., Int, Bool)
            }
            
        }, to: urlString, method: .post, headers: headers)
        .responseJSON { response in
            debugPrint(response)
            switch response.result {
            case .success(let value):
                if let responseValue = value as? [String: Any] {
                    if let message = responseValue[WSResponseParams.WS_RESP_PARAM_MESSAGE] as? String, message == Strings.SUCCESSFULLY_UPLOAD_PROFILE_PIC {
                        completion(true, "\(message)", [:])
                    } else {
                        completion(false, "Unexpected response from server", [:])
                    }
                } else {
                    completion(false, "Unexpected response format", [:])
                }
            case .failure(let error):
                completion(false, error.localizedDescription, [:])
            }
        }
    }
}
