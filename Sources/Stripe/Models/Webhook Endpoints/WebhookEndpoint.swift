//
//  WebhookEndpoint.swift
//  Stripe
//
//  Created by zach wick <zach@zachwick.com> on 2019-05-15
//
//

import Foundation

/// The [Webhook Endpoint Object](https://stripe.com/docs/api/webhook_endpoints/object)
public struct StripeWebhookEndpoint: StripeModel {
    /// Unique identifier for the object.
    public var id: String
    /// String representing the object’s type. Objects of the same type share the same value.
    public var object: String
    /// The API version events are rendered as for this webhook endpoint.
    public var api_version: String?
    /// The ID of the associated Connect application.
    public var application: String?
    /// Time at which the object was created. Measured in seconds since the Unix epoch.
    public var created: Date?
    /// The list of events to enable for this endpoint. You may specify ['*'] to enable all events.
    public var enabled_events: [String?]
    /// Has the value true if the object exists in live mode or the value false if the object exists in test mode.
    public var livemode: Bool?
    /// The endpoint’s secret, used to generate webhook signatures. Only returned at creation.
    public var secret: String?
    /// The status of the webhook. It can be enabled or disabled.
    public var status: StripeWebhookEndpointStatus?
    /// The URL of the webhook endpoint.
    public var url: String?
}

public enum StripeWebhookEndpointStatus: String, StripeModel {
  case enabled
  case disabled
}

public struct StripeWebhookEndpointList: StripeModel {
  public var object: String
  public var url: String?
  public var hasMore: Bool?
  public var data: [StripeWebhookEndpoint]?
}