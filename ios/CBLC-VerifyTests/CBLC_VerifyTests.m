//
//  CBLC_VerifyTests.m
//  CBLC-VerifyTests
//
//  Created by Pasin Suriyentrakorn on 4/26/23.
//

#import <XCTest/XCTest.h>
#import "Verification.h"

@interface CBLC_VerifyTests : XCTestCase

@end

@implementation CBLC_VerifyTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testVerification {
    Verification* v = [[Verification alloc] init];
    XCTAssertTrue([v verify]);
}

@end
