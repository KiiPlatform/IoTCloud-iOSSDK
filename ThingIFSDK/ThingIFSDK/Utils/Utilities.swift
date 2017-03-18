//
//  Utilities.swift
//  ThingIFSDK
//
//  Created on 2017/03/06.
//  Copyright (c) 2017 Kii. All rights reserved.
//

import Foundation

internal func +<Key, Value>(
  left: [Key : Value],
  right: [Key : Value]) -> [Key : Value]
{
    var retval = left
    for (key, value) in right {
        retval[key] = value
    }
    return retval
}

internal func +=<Key, Value>(left: inout [Key : Value], right: [Key : Value]) {
    right.forEach { left[$0.0] = $0.1 }
}

internal func convertResonse<Item, Response: CustomStringConvertible>(
  _ json: Response?,
  _ error: ThingIFError?,
  _ parser: (Response?, ThingIFError?) throws -> (Item?, ThingIFError?))
  -> (Item?, ThingIFError?)
{
    do {
        return try parser(json, error)
    } catch ThingIFError.jsonParseError {
        kiiSevereLog(
          "Server error. Response is not satisfied the spec." +
            (json?.description ?? ""))
        return (nil, ThingIFError.jsonParseError)
    } catch let error {
        kiiSevereLog(
          "Unexpected error." +
            error.localizedDescription)
        return (nil, ThingIFError.jsonParseError)
    }
}

internal func parseResponse<ParsableType: FromJsonObject>(
  _ response: [String : Any]?,
  _ error: ThingIFError?) -> (ParsableType?, ThingIFError?)
{
    return convertResonse(response, error) {
        response, error -> (ParsableType?, ThingIFError?) in

        if error != nil {
            return (nil, error)
        }
        return (try ParsableType(response!), nil)
    }
}

internal extension OperationQueue {

    func addHttpRequestOperation(
      _ method: HTTPMethod,
      url: String,
      requestHeader: [String : String],
      requestBody: [String : Any]? = nil,
      failureBeforeExecutionHandler: @escaping (_ error: ThingIFError) -> Void,
      completionHandler:
        @escaping (_ response: [String : Any]?,
                   _ error: ThingIFError?) -> Void) -> Void
    {
        let data: Data?
        if let requestBody = requestBody {
            do {
                data = try JSONSerialization.data(
                  withJSONObject: requestBody,
                  options: JSONSerialization.WritingOptions(rawValue: 0))
            } catch let error {
                kiiSevereLog(error)
                failureBeforeExecutionHandler(ThingIFError.jsonParseError)
                return
            }
        } else {
            data = nil
        }

        self.addOperation(
          IoTRequestOperation(
            request: buildDefaultRequest(
              method,
              urlString: url,
              requestHeaderDict: requestHeader,
              requestBodyData: data) { response, error in
                completionHandler(response, error)
            }
          )
        )
    }
}
