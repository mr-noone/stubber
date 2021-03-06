//
//  HTTPMessageTests.swift
//  StubberTests
//
//  Created by Aleksey Zgurskiy on 05.06.2018.
//  Copyright © 2018 Graviti Mobail, TOV. All rights reserved.
//

import XCTest
@testable import HTTPStubber

class HTTPMessageTests: XCTestCase {
  var message: HTTPMessage!
  
  func setUpWith(message: String, isRequest: Bool) {
    self.message = HTTPMessage(data: message.data(using: .utf8)!, isRequest: isRequest)
  }
  
  override func tearDown() {
    message = nil
    super.tearDown()
  }
  
  //MARK: - Response tests
  
  func testResponseHTTPMessageStatusCode() {
    setUpWith(message: "HTTP/1.1 204\n\n", isRequest: false)
    XCTAssertEqual(message.statusCode, 204)
  }
  
  func testResponseHTTPMessageHost() {
    setUpWith(message: "HTTP/1.1 200\n\n", isRequest: false)
    XCTAssertNil(message.host)
  }
  
  func testResponseHTTPMessagePath() {
    setUpWith(message: "HTTP/1.1 200\n\n", isRequest: false)
    XCTAssertNil(message.path)
  }
  
  func testResponseHTTPMessageMethod() {
    setUpWith(message: "HTTP/1.1 200\n\n", isRequest: false)
    XCTAssertNil(message.method)
  }
  
  //MARK: - Request tests
  
  func testRequestHTTPMessageStatusCode() {
    setUpWith(message: "POST / HTTP/1.1\n\n", isRequest: true)
    XCTAssertEqual(message.statusCode, 0)
  }
  
  func testRequestHTTPMessageHost() {
    setUpWith(message: "POST / HTTP/1.1\nHost: 127.0.0.1\n\n", isRequest: true)
    XCTAssertEqual(message.host, "127.0.0.1")
  }
  
  func testRequestHTTPMessagePath() {
    setUpWith(message: "POST /path/to HTTP/1.1\n\n", isRequest: true)
    XCTAssertEqual(message.path, "/path/to")
  }
  
  func testRequestHTTPMessageMethod() {
    setUpWith(message: "TEST / HTTP/1.1\n\n", isRequest: true)
    XCTAssertEqual(message.method, "TEST")
  }
  
  func testRequestSerializedMessage() {
    var request = URLRequest(url: URL(string: "http://127.0.0.1/path?id=123&key=value")!)
    request.addValue("key1", forHTTPHeaderField: "value1")
    request.addValue("key2", forHTTPHeaderField: "value2")
    request.httpBody = "{\"key\":\"value\"}".data(using: .utf8)
    
    let message = HTTPMessage(request: request)
    let messageStr =
"""
GET /path?id=123&key=value HTTP/1.1\r
Host: 127.0.0.1\r
value2: key2\r
value1: key1\r
\r
{"key":"value"}
"""
    
    XCTAssertEqual(message?.serializedMessage, messageStr)
  }
  
  //MARK: - Common tests
  
  func testHTTPMessageHTTPVersion() {
    setUpWith(message: "POST / HTTP/0.9\n\n", isRequest: true)
    XCTAssertEqual(message.httpVersion, "HTTP/0.9")
  }
  
  func testHTTPMessageHTTPVersionEmpty() {
    setUpWith(message: "POST /\n\n", isRequest: true)
    XCTAssertNil(message.httpVersion)
  }
  
  func testHTTPMessageHeadersEmpty() {
    setUpWith(message: "HTTP/1.1 200\n\n", isRequest: false)
    XCTAssertNil(message.headers)
  }
  
  func testHTTPMessageHeadersNotEmpty() {
    setUpWith(message: "HTTP/1.1 200\nKeep-Alive: 5\n\n", isRequest: false)
    XCTAssertEqual(message.headers, ["Keep-Alive" : "5"])
  }
  
  func testHTTPMessageBodyEmpty() {
    setUpWith(message: "HTTP/1.1 200\n\n", isRequest: false)
    XCTAssertNil(message.body)
  }
  
  func testHTTPMessageBodyNotEmpty() {
    setUpWith(message: "HTTP/1.1 200\n\nBody", isRequest: false)
    XCTAssertEqual(message.body, "Body".data(using: .utf8))
  }
}
