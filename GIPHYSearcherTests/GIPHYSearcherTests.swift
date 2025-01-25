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
        let url = "\(TestAPI.baseURL)\(TestAPI.Endpoint.trending)"
        guard let validUrl = URL(string: url) else {
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
        let sut = GiphyAPIManager(apiKey: TestAPI.apiKey, delegate: mockDelegate, session: mockURLSession)
        
        sut.fetchTrending()
        
        XCTAssertEqual(mockDelegate.receivedData?.count, 1, "데이터 개수가 일치하지 않음")
        XCTAssertEqual(mockDelegate.receivedData?.first?.title, "Test GIF",  "GIF 이름이 예상과 다름")
        XCTAssertEqual(mockDelegate.receivedData?.first?.url, "https://example.com/gif1")
        XCTAssertNil(mockDelegate.receivedError)
    }
    
    func testFetchTrendingWithEmptyData() {
        let mockResponse: MockURLSession.Response = {
            let emptyData = "{\"data\": []}".data(using: .utf8)!
            let successResponse = HTTPURLResponse(url: URL(string: "https://example.com")!,
                                                  statusCode: 200,
                                                  httpVersion: nil,
                                                  headerFields: nil)
            return (data: emptyData, reponse: successResponse, error: nil)
        }()
        
        let mockURLSession = MockURLSession(response: mockResponse)
        let mockDelegate = MockDelegate()
        let sut = GiphyAPIManager(apiKey: TestAPI.apiKey, delegate: mockDelegate, session: mockURLSession)
        
        sut.fetchTrending()
        
        XCTAssertEqual(mockDelegate.receivedData?.count, 0, "빈 데이터가 반환되지 않았음")
        XCTAssertNil(mockDelegate.receivedError, "오류가 발생하지 않아야 함")
    }
    
    func testUpdateUIWithEmptyData() {
        let viewController = MainViewController()
        viewController.loadViewIfNeeded()
        
        gifData = []
        
        viewController.updateEmptyState(isEmpty: true)
        
        XCTAssertFalse(viewController.emptyStateLabel.isHidden)
        XCTAssertTrue(viewController.gifCollectionView.isHidden)
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
