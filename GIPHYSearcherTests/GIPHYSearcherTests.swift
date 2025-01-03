//
//  GIPHYSearcherTests.swift
//  GIPHYSearcherTests
//
//  Created by 강민지 on 12/10/24.
//

import XCTest
@testable import GIPHYSearcher

final class GIPHYSearcherTests: XCTestCase {
    func testFetchTrending() {
        let url = "\(API.baseURL)\(API.Endpoint.trending)"
        guard let validUrl = URL(string: url) else {
            XCTFail("URL 생성 실패")
            return
        }
        
        let mockResponse: MockURLSession.Response = {
            let data = JsonLoader.data(fileName: "MockTrending")
            let successResponse = HTTPURLResponse(url: validUrl,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
            return (data: data, reponse: successResponse, error: nil)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        let mockDelegate = MockDelegate()
        let sut = GiphyAPIManager(delegate: mockDelegate, session: mockURLSession)
        
        sut.fetchTrending()
        
        XCTAssertEqual(mockDelegate.receivedData?.count, 1, "데이터 개수가 일치하지 않음")
        XCTAssertEqual(mockDelegate.receivedData?.first?.title, "TestGIF",  "GIF 이름이 예상과 다름")
        XCTAssertEqual(mockDelegate.receivedData?.first?.url, "https://example.com/gif1")
        XCTAssertNil(mockDelegate.receivedError)
    }
}

final class MockDelegate: GiphyAPIManagerDelegate {
    var receivedData: [gifDataModel]?
    var receivedError: NetworkError?
    
    func didUpdateData(data: [gifDataModel]) {
        receivedData = data
    }
    
    func didFailWithError(error: NetworkError) {
        receivedError = error
    }
}
