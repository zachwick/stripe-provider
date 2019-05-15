//
//  WebhookEndpointRoutes.swift
//  Stripe
//
//  Created by zach wick <zach@zachwick.com> on 2019-05-15
//
//

import NIO
import NIOHTTP1

public protocol WebhookEndpointRoutes {
    /// Retrieves the webhook endpoint with the given ID.
    ///
    /// - Parameter webhook_endpoint: The ID of the desired webhook endpoint.
    /// - Returns: Returns a `StripeWebhookEndpoint`
    /// - Throws: A `StripeError`.
    func retrieve(id: String) throws -> EventLoopFuture<StripeWebhookEndpoint>

    /// Returns a list of your webhook endpoints.
    ///
    /// - Parameter filter: A dictionary that will be used for the query parameters. [See More →](https://stripe.com/docs/api/webhook_endpoints/list).
    /// - Returns: A `StripeWebhookEndpointList`.
    /// - Throws: A `StripeError`.
    func listAll(filter: [String: Any]?) throws -> EventLoopFuture<StripeWebhookEndpointList>
    
    mutating func addHeaders(_ : HTTPHeaders)
}

extension WebhookEndpointRoutes {
    public func retrieve(id: String) throws -> EventLoopFuture<StripeWebhookEndpoint> {
        return try retrieve(id: id)
    }
    
    public func listAll(filter: [String: Any]? = nil) throws -> EventLoopFuture<StripeWebhookEndpointList> {
        return try listAll(filter: filter)
    }
}

public struct StripeWebhookEndpointRoutes: WebhookEndpointRoutes {
    private let apiHandler: StripeAPIHandler
    private var headers: HTTPHeaders = [:]
    
    init(apiHandler: StripeAPIHandler) {
        self.apiHandler = apiHandler
    }
    
    public mutating func addHeaders(_ _headers: HTTPHeaders) {
        _headers.forEach { self.headers.replaceOrAdd(name: $0.name, value: $0.value) }
    }
    
    public func retrieve() throws -> EventLoopFuture<StripeWebhookEndpoint> {
        return try apiHandler.send(method: .GET, path: StripeAPIEndpoint.webhookEndpoint.endpoint, headers: headers)
    }
    
    public func retrieve(id: String) throws -> EventLoopFuture<StripeWebhookEndpoint> {
        return try apiHandler.send(method: .GET, path: StripeAPIEndpoint.webhookEndpoints(id).endpoint, headers: headers)
    }
    
    public func listAll(filter: [String: Any]?) throws -> EventLoopFuture<StripeWebhookEndpointList> {
        var queryParams = ""
        if let filter = filter {
            queryParams = filter.queryParameters
        }
        return try apiHandler.send(method: .GET, path: StripeAPIEndpoint.webhookEndpoint.endpoint, query: queryParams, headers: headers)
    }
}
