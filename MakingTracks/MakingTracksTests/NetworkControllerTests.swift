//
//  NetworkControllerTests.swift
//  MakingTracksTests
//
//  Created by user169372 on 5/15/20.
//  Copyright © 2020 John. All rights reserved.
//

import XCTest
import MapKit
@testable import MakingTracks

class NetworkControllerTests: XCTestCase, NetworkControllerDelegate {
    
    //Expectation needed to test call to NetworkControllerDelegate method which is called in a callback
    private var healthCheckExpectation: XCTestExpectation?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
         
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHealthCheckMethod() throws
    {
        //Setup
        healthCheckExpectation = expectation(description: "Health check fetch")
        NetworkController.shared.delegate = self
        
        NetworkController.shared.APIhealthCheck()
        
        waitForExpectations(timeout: 10.0) {error in
            print(error?.localizedDescription as Any)
        }
    }
    //NetworkControllerDelegate method, called from the completion handler of NetworkController.shared.APIhealthCheck() from above test
    func dataDecodingComplete(_ decodedData: Any)
    {
        if let healthCheck = decodedData as? PTVAPIHealthCheckModel
        {
            XCTAssertTrue(healthCheck.securityTokenOK)
            healthCheckExpectation?.fulfill()
        }
        else
        {
            XCTFail()
        }

    }

    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
