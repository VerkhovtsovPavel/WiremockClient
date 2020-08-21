//
//  StubMapping.swift
//  WiremockClient
//
//  Created by Ted Rothrock on 6/23/17.
//  Copyright © 2017 Ted Rothrock. All rights reserved.
//

import Foundation

/// A collection of conditons used to determine matches based on request attributes including headers, cookies, parameters, request body, JSON, XML, and XPath
public enum MatchCondition: String {
    /// An exact match
    case equalTo
    
    /// A match containing a value
    case contains
    
    /// A match by regex pattern
    case matches
    
    /// A negative match
    case doesNotMatch
    
    /// A semantic match of valid JSON
    case equalToJson
    
    /// A JSON attribute non-nil value match
    case matchesJsonPath
    
    /// A semantic match of valid XML
    case equalToXml
    
    /// An XML path non-nil value match
    case matchesXPath
}

/// An object used to configure a Wiremock server stub mapping. Refer to http://wiremock.org/docs/stubbing/ and http://wiremock.org/docs/request-matching/ for more details.
public class StubMapping {
    private var request: RequestMapping
    private var response: ResponseDefinition?
    private var uuid: UUID
    private var name: String?
    private var priority: Int?
    private var scenarioName: String?
    private var requiredScenarioState: String?
    private var newScenarioState: String?
    
    private init(requestMethod: RequestMethod, urlMatchCondition: URLMatchCondition, url: String) {
        self.request = RequestMapping.requestFor(requestMethod: requestMethod, urlMatchCondition: urlMatchCondition, url: url)
        self.uuid = UUID()
    }
    
    //----------------------------------
    // MARK: Mapping Builder Methods
    //----------------------------------
    
    /// Initializes a `StubMapping`
    ///
    /// - Parameter requestMethod: The HTTP request method to match
    /// - Parameter urlMatchCondition: A condition used to match the URL path and parameters of a request to a mapping
    /// - Parameter url: The URL path and parameter pattern that the mapping will use to match requests
    /// - Returns: A configured `StubMapping`
    public static func stubFor(requestMethod: RequestMethod, urlMatchCondition: URLMatchCondition, url: String) -> StubMapping {
        return StubMapping(requestMethod: requestMethod, urlMatchCondition: urlMatchCondition, url: url)
    }
    
    /// Adds a unique identifier to a mapping
    ///
    /// - Parameter uuid: The unique identifier to add
    /// - Returns: The `StubMapping` with an updated identifier
    public func withUUID(_ uuid: UUID) -> StubMapping {
        self.uuid = uuid
        return self
    }
    
    /// Adds a priority ranking to a mapping. Used to determine the order in which multiple matching mappings are evaluated.
    ///
    /// - Parameter priority: An `Int` representing the mapping's priority. 1 is the highest priority.
    /// - Returns: The `StubMapping` with an updated priority
    public func withPriority(_ priority: Int) -> StubMapping {
        self.priority = priority
        return self
    }
    
    /// Adds a scenario name to a mapping. This is an identifier used to group scenario states.
    ///
    /// - Parameter scenarioName: The scenario name to add
    /// - Returns: The `StubMapping` with an updated scenario name
    public func inScenario(_ scenarioName: String) -> StubMapping {
        self.scenarioName = scenarioName
        return self
    }
    
    /// Adds a required scenario state to a mapping. The mapping will only match a request when the matching scenario state is active.
    /// - Parameter scenarioState: The name of the required scenario state
    /// - Returns: The `StubMapping` with an updated required scenario state
    public func whenScenarioStateIs(_ scenarioState: String) -> StubMapping {
        self.requiredScenarioState = scenarioState
        return self
    }
    
    /// Adds a new scenario state to a mapping. Matching this mapping will update the scenario state to this new value.
    ///
    /// - Parameter scenarioState: The name of the new scenario state
    /// - Returns: The `StubMapping` with an updated new scenario state
    public func willSetStateTo(_ scenarioState: String) -> StubMapping {
        self.newScenarioState = scenarioState
        return self
    }
    
    /// Adds a header match condition to a mapping
    ///
    /// - Parameter key: The header key
    /// - Parameter matchCondition: The condition under which the header will be evaluated as a match
    /// - Parameter value: The header value
    /// - Returns: The `StubMapping` with an updated header match condition
    public func withHeader(_ key: String, matchCondition: MatchCondition, value: String) -> StubMapping {
        _ = self.request.withHeader(key, matchCondition: matchCondition, value: value)
        return self
    }
    
    /// Adds a cookie match condition to a mapping
    ///
    /// - Parameter key: The cookie key
    /// - Parameter matchCondition: The condition under which the cookie will be evaluated as a match
    /// - Parameter value: The cookie value
    /// - Returns: The `StubMapping` with an updated cookie match condition
    public func withCookie(_ key: String, matchCondition: MatchCondition, value: String) -> StubMapping {
        _ = self.request.withCookie(key, matchCondition: matchCondition, value: value)
        return self
    }
    
    /// Adds a query parameter match condition to a mapping
    ///
    /// - Parameter param: The param key
    /// - Parameter matchCondition: The condition under which the param will be evaluated as a match
    /// - Parameter value: The param value
    /// - Returns: The `StubMapping` with an updated param match condition
    public func withQueryParam(_ param: String, matchCondition: MatchCondition, value: String) -> StubMapping {
        _ = self.request.withQueryParam(param, matchCondition: matchCondition, value: value)
        return self
    }
    
    /// Adds a basic authentication match condition to a mapping
    ///
    /// - Parameter username: The username to evaluate
    /// - Parameter password: The password to evaluate
    /// - Returns: The `StubMapping` with an updated basic authentication match condition
    public func withBasicAuth(username: String, password: String) -> StubMapping {
        _ = self.request.withBasicAuth(username: username, password: password)
        return self
    }
    
    /// Adds a request body match condition to a mapping
    ///
    /// - Parameter matchCondition: The condition under which the body will be evaluated as a match
    /// - Parameter value: The body value
    /// - Returns: The `StubMapping` with an updated body match condition
    public func withRequestBody(_ matchCondition: MatchCondition, value: String) -> StubMapping {
        _ = self.request.withRequestBody(matchCondition, value: value)
        return self
    }
    
    /// Adds a request JSON match condition to a mapping
    ///
    /// - Parameter jsonString: The request JSON value in `String` form
    /// - Parameter ignoreArrayOrder: A flag that indicates if matching JSON must contain elements in an exact order
    /// - Parameter ignoreExtraElements: A flag that indicates if matching JSON must not contain extra elements
    /// - Returns: The `StubMapping` with an updated JSON match condition
    public func withRequestBodyEqualToJson(jsonString: String, ignoreArrayOrder: Bool, ignoreExtraElements: Bool) -> StubMapping {
        _ = self.request.withRequestBodyEqualToJson(jsonString: jsonString, ignoreArrayOrder: ignoreArrayOrder, ignoreExtraElements: ignoreExtraElements)
        return self
    }
    
    /// Adds a response object to a mapping
    ///
    /// - Parameter response: The `ResponseDefinition` object used to configure the Wiremock server response
    /// - Returns: The `StubMapping` with an updated `ResponseDefinition`
    public func willReturn(_ response: ResponseDefinition?) -> StubMapping {
        self.response = response
        return self
    }
    
    //----------------------------------
    // MARK: Mapping to Data Conversion
    //----------------------------------
    
    // Mapping Key Names
    
    let keyUuid             = "uuid"
    let keyMethod           = "method"
    let keyPriority         = "priority"
    let keyScenName         = "scenarioName"
    let keyReqScen          = "requiredScenarioState"
    let keyNewScen          = "newScenarioState"
    let keyRequest          = "request"
    let keyBody             = "body"
    let keyStatus           = "status"
    let keyStatusMessage    = "statusMessage"
    let keyResponse         = "response"
    let keyParams           = "queryParameters"
    let keyBodyFile         = "bodyFileName"
    let keyProxyUrl         = "proxyBaseUrl"
    let keyHeaders          = "headers"
    let keyCookies          = "cookies"
    let keyBasicAuth        = "basicAuthCredentials"
    let keyBodyPatterns     = "bodyPatterns"
    let keyTransformers     = "transformers"
    
    internal func asData() -> Data? {
        
        var mappingDict = [String: Any]()
        
        // UUID
        
        mappingDict[keyUuid] = self.uuid.uuidString
        
        // Priority
        
        if let priority = self.priority {
            mappingDict[keyPriority] = priority
        }
        
        // Scenarios
        
        if let scenarioName = self.scenarioName {
            mappingDict[keyScenName] = scenarioName
        }
        
        if let requiredScenarioState = self.requiredScenarioState {
            mappingDict[keyReqScen] = requiredScenarioState
        }
        
        if let newScenarioState = self.newScenarioState {
            mappingDict[keyNewScen] = newScenarioState
        }
        
        /**** REQUEST ****/
        
        mappingDict[keyRequest] = self.request.requestDict()
        
        /**** RESPONSE ****/
        
        var responseDict = [String: Any]()
        
        if let response = self.response {
            
            // Body
            
            if let responseBody = response.body {
                responseDict[keyBody] = responseBody
            }
            
            // Status
            
            if let responseStatus = response.status {
                responseDict[keyStatus] = responseStatus
            }
            
            // Status Message
            
            if let statusMessage = response.statusMessage {
                responseDict[keyStatusMessage] = statusMessage
            }
            
            // Body File Name
            
            if let bodyFileName = response.bodyFileName {
                responseDict[keyBodyFile] = bodyFileName
            }
            
            // Proxy Base URL
            
            if let proxyBaseUrl = response.proxyBaseUrl {
                responseDict[keyProxyUrl] = proxyBaseUrl
            }
            
            // Headers
            
            if let headers = response.headers {
                responseDict[keyHeaders] = headers
            }
            
            // Transformers
            
            if let transformers = response.transformers {
                responseDict[keyTransformers] = transformers.map { $0.rawValue }
            }
        }
        
        mappingDict[keyResponse] = responseDict
        
        return try? JSONSerialization.data(withJSONObject: mappingDict, options: [.prettyPrinted])
    }
}
