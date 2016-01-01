//
//  YelpClient.swift
//  zalon
//
//  Created by el rs on 12/27/15.
//  Copyright © 2015 hap. All rights reserved.
//

import Foundation
import Alamofire
import OAuthSwift

struct YelpAPIConsole {
    var consumerKey = "FNiyhu36TQCxiuETwL6Qbw"
    var consumerSecret = "APXSpfpLMUhUDNq7WBqxBELWHoA"
    var accessToken = "gMXgOwZ6FtR4Wi4pMGYElZXzbOGpKbAl"
    var accessTokenSecret = "BmKnZQ5QnlsafVgNiI6oK7wdhcE"
}

/*
class OAuthRequestBuilder: NSObject {
    
    class func makeRequest(URL: NSURL, method: String, headers: [String : String], parameters: Dictionary<String, AnyObject>, dataEncoding : NSStringEncoding) -> NSMutableURLRequest {
        var request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = method
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let charset = CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(dataEncoding))
        
        var nonOAuthParameters = parameters.filter { key, _ in !key.hasPrefix("oauth_") }
        
        if nonOAuthParameters.count > 0 {
            if request.HTTPMethod == "GET" || request.HTTPMethod == "HEAD" || request.HTTPMethod == "DELETE" {
                let queryString = nonOAuthParameters.urlEncodedQueryStringWithEncoding(dataEncoding)
                request.URL = URL.URLByAppendingQueryString(queryString)
                request.setValue("application/x-www-form-urlencoded; charset=\(charset)", forHTTPHeaderField: "Content-Type")
            }
            else {
                var error: NSError?
                if let jsonData: NSData = NSJSONSerialization.dataWithJSONObject(nonOAuthParameters, options: nil, error: &error)  {
                    request.setValue("application/json; charset=\(charset)", forHTTPHeaderField: "Content-Type")
                    request.HTTPBody = jsonData
                }
                else {
                    println(error!.localizedDescription)
                }
            }
        }
        return request
    }
}
*/

enum YelpRouter: URLRequestConvertible {

    // Cases
    case Nothing
    case Search(Dictionary<String, String>)
    
    // Initialization
    static let baseURL = "https://api.yelp.com/v2/"
    static var oauthClient : OAuthSwiftClient!
    
    init() {
        let apiConsoleInfo = YelpAPIConsole()
        YelpRouter.oauthClient = OAuthSwiftClient(consumerKey: apiConsoleInfo.consumerKey, consumerSecret: apiConsoleInfo.consumerSecret, accessToken: apiConsoleInfo.accessToken, accessTokenSecret: apiConsoleInfo.accessTokenSecret)
//        YelpRouter.oauthClient.credential.version = OAuthSwiftCredential.Version.OAuth2;
        let emptyDic = [String: String]()
        self = .Nothing
    }
    
    var method: Alamofire.Method {
        switch self {
        case .Nothing:
            return .GET
        case .Search:
            return .GET
        }
    }

    var path: String {
        switch self {
        case .Search:
            return "search/"
        case .Nothing:
            return "-/"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        
        let URL = NSURL(string: YelpRouter.baseURL)!
        let URLWithPath = URL.URLByAppendingPathComponent(path)
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        
        switch self {
        case .Search(let parameters):
            print ("Calling search with \(parameters)")
            /*
            let hdrs=YelpRouter.oauthClient.credential.makeHeaders(URLWithPath, method: OAuthSwiftHTTPRequest.Method.GET, parameters: parameters)
*/
            var auth = YelpRouter.oauthClient.credential.authorizationHeaderForMethod(OAuthSwiftHTTPRequest.Method.GET,
                url: URLWithPath,
                parameters: parameters)
            auth=auth.componentsSeparatedByString("oauth_token=\"")[1]
            auth=auth.componentsSeparatedByString("\",")[0]
            print ("header auth value \(auth)")
//            mutableURLRequest.setValue(hdrs["Authorization"], forHTTPHeaderField: "Authorization")
//            mutableURLRequest.setValuesForKeysWithDictionary(hdrs)
            mutableURLRequest.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization")
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }

}

class YelpClient: NSObject {
    
    let APIBaseUrl = "https://api.yelp.com/v2/"
    let clientOAuth: OAuthSwiftClient?
    let apiConsoleInfo: YelpAPIConsole
    
    override init() {
        apiConsoleInfo = YelpAPIConsole()
        self.clientOAuth = OAuthSwiftClient(consumerKey: apiConsoleInfo.consumerKey, consumerSecret: apiConsoleInfo.consumerSecret, accessToken: apiConsoleInfo.accessToken, accessTokenSecret: apiConsoleInfo.accessTokenSecret)
        super.init()
    }
    
    /*
    
    searchPlacesWithParameters: Function that can search for places using any specified API parameter
    
    Arguments:
    
    searchParameters: Dictionary<String, String>, optional (See https://www.yelp.co.uk/developers/documentation/v2/search_api )
    successSearch: success callback with data (NSData) and response (NSHTTPURLResponse) as parameters
    failureSearch: error callback with error (NSError) as parameter
    
    Example:
    
    var parameters = ["ll": "37.788022,-122.399797", "category_filter": "burgers", "radius_filter": "3000", "sort": "0"]
    
    searchPlacesWithParameters(parameters, successSearch: { (data, response) -> Void in
    println(NSString(data: data, encoding: NSUTF8StringEncoding))
    }, failureSearch: { (error) -> Void in
    println(error)
    })
    
    
    */
    
    func searchPlacesWithParameters(searchParameters: Dictionary<String, String>, successSearch: (data: NSData, response: NSHTTPURLResponse) -> Void, failureSearch: (error: NSError) -> Void) {
        let searchUrl = APIBaseUrl + "search/"
        clientOAuth!.get(searchUrl, parameters: searchParameters, success: successSearch, failure: failureSearch)
    }
    
    /*
    
    getBusinessInformationOf: Retrieve all the business data using the id of the place
    
    Arguments:
    
    businessId: String
    localeParameters: Dictionary<String, String>, optional (See https://www.yelp.co.uk/developers/documentation/v2/business )
    successSearch: success callback with data (NSData) and response (NSHTTPURLResponse) as parameters
    failureSearch: error callback with error (NSError) as parameter
    
    Example:
    
    getBusinessInformationOf("custom-burger-san-francisco", successSearch: { (data, response) -> Void in
    println(NSString(data: data, encoding: NSUTF8StringEncoding))
    }) { (error) -> Void in
    println(error)
    }
    
    */
    
    func getBusinessInformationOf(businessId: String, localeParameters: Dictionary<String, String>? = nil, successSearch: (data: NSData, response: NSHTTPURLResponse) -> Void, failureSearch: (error: NSError) -> Void) {
        let businessInformationUrl = APIBaseUrl + "business/" + businessId
        var parameters = localeParameters
        if parameters == nil {
            parameters = Dictionary<String, String>()
        }
        clientOAuth!.get(businessInformationUrl, parameters: parameters!, success: successSearch, failure: failureSearch)
    }
    
    /*
    
    searchBusinessWithPhone: Search for a business using a telephone number
    
    Arguments:
    
    phoneNumber: String
    searchParameters: Dictionary<String, String>, optional (See https://www.yelp.co.uk/developers/documentation/v2/phone_search )
    successSearch: success callback with data (NSData) and response (NSHTTPURLResponse) as parameters
    failureSearch: error callback with error (NSError) as parameter
    
    Example:
    
    searchBusinessWithPhone("+15555555555", successSearch: { (data, response) -> Void in
    println(NSString(data: data, encoding: NSUTF8StringEncoding))
    }) { (error) -> Void in
    println(error)
    }
    
    */
    
    func searchBusinessWithPhone(phoneNumber: String, searchParameters: Dictionary<String, String>? = nil, successSearch: (data: NSData, response: NSHTTPURLResponse) -> Void, failureSearch: (error: NSError) -> Void) {
        let phoneSearchUrl = APIBaseUrl + "phone_search/"
        var parameters = searchParameters
        if parameters == nil {
            parameters = Dictionary<String, String>()
        }
        
        parameters!["phone"] = phoneNumber
        
        clientOAuth!.get(phoneSearchUrl, parameters: parameters!, success: successSearch, failure: failureSearch)
    }
}