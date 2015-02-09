//
//  MovieDetailViewController.m
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/4/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@end

@implementation MovieDetailViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = self.movie[@"title"];
	[self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+20)];
	NSString *url = [self.movie valueForKeyPath:@"posters.original"];	
	[self.posterView setImageWithURL:[NSURL URLWithString:url]];
	
	NSString *originalUrl = [self getOriginalUrl:url];
	[self.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:originalUrl]]
						   placeholderImage:nil
									success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
										[self.posterView setImage:image];
										
									}
									failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
										NSLog(@"failed loading: %@", error);
									}
	];
	
	
	self.titleLabel.text = self.movie[@"title"];
	[self.titleLabel sizeToFit];
	
	self.synopsisLabel.text = self.movie[@"synopsis"];
	[self.synopsisLabel sizeToFit];
	
	// Move the synopsis label down a bit to accomodate for potential line wraps in the title
	self.synopsisLabel.frame = CGRectMake(7, 5 + self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, self.containerView.frame.size.width-22, 0);
	[self.synopsisLabel sizeToFit];
	
	CGRect newBackgroundViewFrame = self.containerView.frame;
	newBackgroundViewFrame.origin.y = self.view.frame.size.height-100;
	newBackgroundViewFrame.size.height = self.synopsisLabel.frame.origin.y + self.synopsisLabel.frame.size.height+8;// + 120;
	self.containerView.frame = newBackgroundViewFrame;
	
	[self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.containerView.frame.origin.y + self.containerView.frame.size.height)];// - 180)];
}

-(NSString*) getOriginalUrl:(NSString*)url{
	
	NSRange range = [url rangeOfString:@"." options:NSBackwardsSearch];
	if(range.location == NSNotFound){
		return nil;
	}
	
	NSString *mySmallerString = [url substringToIndex:range.location];
	NSString *extension = [url substringFromIndex:range.location];

	NSRange range1 = [mySmallerString rangeOfString:@"_tmb" options:NSBackwardsSearch];
	if(range1.location == NSNotFound){
		return nil;
	}
	
	NSString *originalUrl;
	if(range1.length == 4 && range1.location == [mySmallerString length]-range1.length){
		originalUrl = [mySmallerString substringToIndex:range1.location];
		originalUrl = [originalUrl stringByAppendingString:@"_ori"];
		originalUrl = [originalUrl stringByAppendingString:extension];
	}
	
	return originalUrl;
}

-(void) viewWillDisappear:(BOOL)animated {
	if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
		self.parentViewController.tabBarController.tabBar.hidden = FALSE;
	}
	[super viewWillDisappear:animated];
}

-(void)didReceiveMemoryWarning {
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
