//
//  MultiCityViewModel.swift
//  LeaveCasa
//
//  Created by acme on 30/12/22.
//

import Foundation
import ObjectMapper

class MultiCityViewModel{
    
    var mealModel = [MealViewModel]()
    var ssrModel : SsrFlightModel?
    
    var delegate : ResponseProtocol?
    
    func getFareSSR(traceId:String,tokenId:String,logId:String,resultIndex:String,view:UIViewController){
        let param = [
            WSResponseParams.WS_RESP_PARAM_TRACE_ID : traceId as AnyObject,
            WSResponseParams.WS_RESP_PARAM_TOKEN : tokenId as AnyObject,
            WSResponseParams.WS_RESP_PARAM_LOGID : logId as AnyObject,
            WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX : resultIndex as AnyObject
        ]
        WebService.callApi(api: .flightFareDetails, method: .post,param: param) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            if status == true{
                if let responseValue = response as? [String: Any] {
                    debugPrint(responseValue)
                    
                    if let ssrModel = Mapper<SsrFlightModel>().map(JSON: responseValue){
                        self.ssrModel = ssrModel
                    }
                    self.delegate?.onSuccess()
                }
                
            }else{
                if msg == CommonError.INTERNET{
                    view.pushNoInterConnection(view: view)
                }else{
                    LoaderClass.shared.stopAnimation()
                    view.pushNoInterConnection(view: view,titleMsg: "Alert", msg: msg)
                }
            }
        }
    }
}
