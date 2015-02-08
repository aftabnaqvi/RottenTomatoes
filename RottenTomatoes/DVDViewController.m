//
//  DVDViewController.m
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/7/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import "DVDViewController.h"

static const NSString *DVD_NEW_RELEASES = @"/lists/dvds//new_releases.json&limit=30";

@interface DVDViewController ()

@end

@implementation DVDViewController

- (void)viewDidLoad {
	self.url = [NSString stringWithFormat:@"%@%@?apikey=%@&limit=30&country=us", BASE_URL, DVD_NEW_RELEASES, API_KEY];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	self.title = @"DVDs";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
