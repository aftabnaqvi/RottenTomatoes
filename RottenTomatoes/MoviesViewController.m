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

@interface MoviesViewController ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation MoviesViewController

- (void)viewDidLoad {
	self.url = [NSString stringWithFormat:@"%@%@?apikey=%@&limit=30&country=us", BASE_URL, BOX_OFFICE_MOVIES, API_KEY];
	[super viewDidLoad];
	
	//NSString *urlString = [NSString stringWithFormat:@"%@%@?apikey=%@", BASE_URL, BOX_OFFICE_LIST_ENDPOINT, API_KEY];
	//NSLog(@"URL: %@", urlString);
	//NSURL *url = [NSURL URLWithString:urlString];
	
	// making a network call
	//NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=rvjna6c6k3mwutfn9hfqmaza&limit=30&country=us"];
//	NSURLRequest *request = [NSURLRequest requestWithURL:url];
//	
//	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//		if(data == nil)
//		{
//			[self createWarningView];
//			[SVProgressHUD dismiss];
//			return;
//		}
//		
//		NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//		NSLog(@"response: %@", responseDictionary);
//		self.movies = responseDictionary[@"movies"];
//		[self.tableView reloadData];
//		[SVProgressHUD dismiss];
//	}];
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
