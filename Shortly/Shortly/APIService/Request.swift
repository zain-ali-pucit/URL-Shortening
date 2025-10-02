//
//  Request.swift
//  Shortly
//
//  Created by Zain Ali on 3/1/22.
//

import Foundation
import RxSwift
import RxCocoa
 
public class RequestObservable
{
    private lazy var jsonDecoder = JSONDecoder()
    private var urlSession: URLSession
    public init(config:URLSessionConfiguration)
    {
        urlSession = URLSession(configuration: URLSessionConfiguration.default)
    }

    public func callAPI<ItemModel: Decodable>(request: URLRequest) -> Observable<ItemModel>
    {
        return Observable.create
        { observer in
            let task = self.urlSession.dataTask(with: request)
            { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse
                {
                    let statusCode = httpResponse.statusCode
                    print(statusCode)
                    do
                    {
                        let _data = data ?? Data()
                        if (200...399).contains(statusCode)
                        {
                            let objs = try self.jsonDecoder.decode(ItemModel.self, from: _data)
                            print(objs)
                            observer.onNext(objs)
                        }
                        else
                        {
                            observer.onError(error!)
                        }
                    }
                    catch
                    {
                        observer.onError(error)
                    }
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create
            {
                task.cancel()
            }
        }
    }
}
