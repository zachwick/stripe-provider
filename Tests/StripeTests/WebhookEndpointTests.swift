//
//  WebhookEndpoint.swift
//  Stripe
//
//  Created by zach wick <zach@zachwick.com> on 2019-05-15
//
//

import XCTest
@testable import Stripe
@testable import Vapor

class WebhookEndpointTests: XCTestCase {
  var decoder: JSONDecoder!

  override func setUp() {
    decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    decode.keyDecodingStrategy = .convertFromSnakeCase
  }

  let webhookEndpointString = """
{
  "id": "we_1EaAyM2eZvKYlo2Cz5NjegJH",
  "object": "webhook_endpoint",
  "api_version": "2019-03-14",
  "application": "ca_123456",
  "created": 1557880074,
  "enabled_events": [
    "charge.failed",
    "charge.succeeded"
  ],
  "livemode": false,
  "status": "enabled",
  "url": "https://example.com/my/webhook/endpoint"
}
"""

  func testWebhookEndpointParsesProperly() throws {
    do {
      let body = HTTPBody(string: webhookEndpointString)
      var headers: HTTPHeaders = [:]
      headers.replaceOrAdd(name: .contentType, value: MediaType.json.description)
      let request = HTTPRequest(headers: headers, body: body)
      let webhookEndpoint = try decoder.decode(StripeWebhookEndpoint.self, from: request, maxSize: 65_536, on: EmbeddedEventLoop()).wait()

      XCTAssertEqual(webhookEndpoint.id, "we_1EaAyM2eZvKYlo2Cz5NjegJH")
      XCTAssertEqual(webhookEndpoint.object, "webhook_endpoint")
      XCTAssertEqual(webhookEndpoint.api_version, "2019-03-14")
      XCTAssertEqual(webhookEndpoint.application, "ca_123456")
      XCTAssertEqual(webhookEndpoint.created, Date(timeIntervalSince1970: 1557880074))
      XCTAssertEqual(webhookEndpoint.enabled_events[0], "charge.failed")
      XCTAssertEqual(webhookEndpoint.enabled_events[1], "charge.succeeded")
      XCTAssertEqual(webhookEndpoint.livemode, false)
      XCTAssertEqual(webhookEndpoint.status, .enabled)
      XCTAssertEqual(webhookEndpoint.url, "https://example.com/my/webhook/endpoint")
    } catch {
      XTCFail("\(error)")
    }
  }
}