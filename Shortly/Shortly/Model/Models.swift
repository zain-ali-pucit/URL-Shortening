//
//  URLModel.swift
//  Shortly
//
//  Created by Zain Ali on 3/1/22.
//

import Foundation

public struct RootModel: Codable
{
    private var ok: Bool
    private var result: URLModel
    
    init(ok: Bool, result: URLModel)
    {
        self.ok = ok
        self.result = result
    }
    
    func getSuccess() -> Bool {
        return self.ok
    }
    
    func getResult() -> URLModel {
        return self.result
    }
}

public struct URLModel: Codable
{
    private var code: String
    private var short_link: String
    private var full_short_link: String
    private var short_link2: String
    private var full_short_link2: String
    private var share_link: String
    private var full_share_link: String
    private var original_link: String
    
    init(code: String, shortLink:String, fullShortLink:String, shortLink2:String, fullShortLink2:String, shareLink:String, fullShareLink:String, originalLink:String)
    {
        self.code = code
        self.short_link = shortLink
        self.full_short_link = fullShortLink
        self.short_link2 = shortLink2
        self.full_short_link2 = fullShortLink2
        self.share_link = shareLink
        self.full_share_link = fullShareLink
        self.original_link = originalLink
    }
    
    func getCode() -> String {
        return self.code
    }
    
    func getShortLink() -> String {
        return self.short_link
    }
    
    func getfullShortLink() -> String {
        return self.short_link
    }
    
    func getshortLink2() -> String {
        return self.short_link2
    }
    
    func getfullShortLink2() -> String {
        return self.full_short_link2
    }
    func getshareLink() -> String {
        return self.share_link
    }
    
    func getfullShareLink() -> String {
        return self.full_share_link
    }
    
    func getoriginalLink() -> String {
        return self.original_link
    }
}

/*
 "code": "KCveN",
       "short_link": "shrtco.de/KCveN",
       "full_short_link": "https://shrtco.de/KCveN",
       "short_link2": "9qr.de/KCveN",
       "full_short_link2": "https://9qr.de/KCveN",
       "share_link": "shrtco.de/share/KCveN",
       "full_share_link": "https://shrtco.de/share/KCveN",
       "original_link": "http://example.org/very/long/link.html"
 */
