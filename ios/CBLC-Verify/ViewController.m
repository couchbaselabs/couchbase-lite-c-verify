//
//  ViewController.m
//  CBLC-Verify
//
//  Created by Pasin Suriyentrakorn on 4/26/23.
//

#import "ViewController.h"
#import "Verification.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Verification* v = [[Verification alloc] init];
    [v verify];
}


@end
