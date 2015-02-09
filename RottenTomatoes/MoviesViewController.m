//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/4/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"

static const NSString *BOX_OFFICE_MOVIES = @"/lists/movies/box_office.json&limit=30";

@interface MoviesViewController ()
@end

@implementation MoviesViewController

- (void)viewDidLoad {
	self.url = [NSString stringWithFormat:@"%@%@?apikey=%@&limit=30&country=us", BASE_URL, BOX_OFFICE_MOVIES, API_KEY];
	[super viewDidLoad];
	self.title = @"Movies";

	// NOTE: I am duplicating this work in both controllers... short of time...
	// this will appear as the title in the navigation bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
	label.backgroundColor = [UIColor clearColor];
	label.font = [UIFont boldSystemFontOfSize:15.0];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = NSTextAlignmentCenter;
	label.textColor = [UIColor colorWithRed:205.0f/255.0f
									  green:153.0f/255.0f
									   blue:255.0f/255.0f
									  alpha:1.0f];

	self.navigationItem.titleView = label;
	label.text = @"Movies";  // here is the title
	[label sizeToFit];
	
	self.navigationController.navigationItem.title = @"Movies";
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
