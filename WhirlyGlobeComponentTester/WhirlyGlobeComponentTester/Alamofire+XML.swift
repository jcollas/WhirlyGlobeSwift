//
//  Alamofire+XML.swift
//  WhirlyGlobeComponentTester
//
//  Created by Juan J. Collas on 12/6/2015.
//  Copyright © 2015 Moreira Consulting, Inc. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    public static func XMLResponseSerializer() -> ResponseSerializer<DDXMLDocument, NSError> {
        return ResponseSerializer { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            
            guard let validData = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            do {
                let XML = try DDXMLDocument(data: validData, options: 0)
                return .Success(XML)
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
    public func responseXMLDocument(completionHandler: Response<DDXMLDocument, NSError> -> Void) -> Self {
        return response(responseSerializer: Request.XMLResponseSerializer(), completionHandler: completionHandler)
    }
}
