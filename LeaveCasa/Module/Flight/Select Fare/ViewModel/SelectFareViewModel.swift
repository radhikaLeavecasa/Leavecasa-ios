//
//  SelectFareViewModel.swift
//  LeaveCasa
//
//  Created by acme on 16/12/22.
//

import Foundation
import ObjectMapper

class SelectFareViewModel{
    //MARK: - Variables
    var mealModel = [MealViewModel]()
    var ssrModel : SsrFlightModel?
    var isMoreInfo = Bool()
    var delegate : ResponseProtocol?
    //MARK: - Get Fare Api
    func getFareSSR(traceId:String,tokenId:String,logId:String,resultIndex:String,view:UIViewController, isMoreInfo: Bool = false, api: Api = .flightFareDetails) {
        LoaderClass.shared.loadAnimation()
        let param = [
            WSResponseParams.WS_RESP_PARAM_TRACE_ID : traceId as AnyObject,
            WSResponseParams.WS_RESP_PARAM_TOKEN : tokenId as AnyObject,
            WSResponseParams.WS_RESP_PARAM_LOGID : logId as AnyObject,
            WSResponseParams.WS_RESP_PARAM_RESULTS_INDEX : resultIndex as AnyObject
        ]
        WebService.callApi(api: api, method: .post, param: param) { status, msg, response in
            LoaderClass.shared.stopAnimation()
            self.isMoreInfo = isMoreInfo
            if status == true{
                if let responseValue = response as? [String: Any] {
                    debugPrint(responseValue)
                    if let ssrModel1 = Mapper<SsrFlightModel>().map(JSON: responseValue) as SsrFlightModel? {
                        self.ssrModel = ssrModel1
                        self.delegate?.onSuccess()
                    }
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
