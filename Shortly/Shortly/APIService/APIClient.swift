//
//  APIClient.swift
//  Shortly
//
//  Created by Zain Ali on 3/1/22.
//

import Foundation
import RxCocoa
import RxSwift

class APIClient
{
    static var shared = APIClient()
    lazy var requestObservable = RequestObservable(config: .default)
  
    func getShortURL(url: String) throws -> Observable<RootModel> {
        var request = URLRequest(url: URL(string: baseURL + shortURLAPI + "url=" + url)!)
        print(request)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return requestObservable.callAPI(request: request)
    }
}
