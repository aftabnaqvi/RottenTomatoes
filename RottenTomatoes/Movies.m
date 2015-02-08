//
//  Movies.m
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/7/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import "Movies.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "MovieCell.h"
#import	"MovieDetailViewController.h"

@interface Movies()
- (void)handleRefresh:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *movies;
@property (nonatomic, strong) UIView *warningView;
@end

@implementation Movies
- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	[SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
	
	// Since we are using a MovieCell here, MovieCell is separate xib file. We need to specify that xib file as nib file here in the code. In order to moviecell loaded by UITablelView.
	[self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
	
	self.tableView.rowHeight = 100;
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:self.refreshControl];
	
	[self handleRefresh:nil];
}
- (void)handleRefresh:(id)sender
{
	// [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
	
	//NSString *urlString = [NSString stringWithFormat:@"%@%@?apikey=%@&limit=30&country=us", BASE_URL, BOX_OFFICE_LIST_ENDPOINT, API_KEY];
	NSURL *nsUrl = [NSURL URLWithString:self.url];
	NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl];
	
	// helper to cleanup the refresh state
	void (^cleanup_refresh_state)(void) = ^{
		self.warningView.hidden = true;
		[(UIRefreshControl *)sender endRefreshing];
		[self.tableView reloadData];
		[SVProgressHUD dismiss];
	};
	
	AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
	operation.responseSerializer = [AFJSONResponseSerializer serializer];
	[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		
		if(responseObject == nil){
			[self createWarningView];
			self.warningView.hidden = false;
			[self.tableView reloadData];
			cleanup_refresh_state();
		}
	
		// Convert the information received in an array of MovieInfo
		self.movies = [[NSMutableArray alloc] init];
		for (NSDictionary *movieDict in responseObject[@"movies"])
		{
			[self.movies addObject:movieDict];
		}
		
		cleanup_refresh_state();
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[self createWarningView];
		self.warningView.hidden = false;
		cleanup_refresh_state();
	}];
	
 
	// Start Operation
	[operation start];
}

-(void) createWarningView
{
	self.warningView = nil;
	self.warningView = [[UIView alloc] initWithFrame:CGRectMake(0,
																self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 40)];
	UILabel *warningLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/4, 0, self.view.frame.size.width/2, 40)];
	warningLabel.text = @"Network Error";
	
	self.warningView.backgroundColor = [UIColor grayColor];
	warningLabel.backgroundColor = [UIColor grayColor];
	[warningLabel setTextAlignment:NSTextAlignmentCenter];
	warningLabel.font = [UIFont systemFontOfSize:20];
	
	//Get pointer to application bundle
	NSBundle *applicationBundle = [NSBundle mainBundle];
	
	//Get path to a resource file in the bundle
	NSString *path = [applicationBundle pathForResource:@"warning_icon"
												 ofType:@"png"];	//Returns nil if not found
	
	UIImage *iconImage = [[UIImage alloc] initWithContentsOfFile:path];
	UIImageView *warningIcon = [[UIImageView alloc] initWithImage:iconImage];
	warningIcon.frame = CGRectMake(self.view.frame.size.width/4, 12, 15, 15); //set these variables as you want
	[warningIcon setBackgroundColor:[UIColor clearColor]];
	
	[self.warningView addSubview:warningLabel];
	[self.warningView addSubview:warningIcon];
	[self.view addSubview:self.warningView];
}


#pragma mark - Table methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.movies.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	//	UITableViewCell *cell = [[UITableViewCell alloc] init]; // never do it...
	
	MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
	NSDictionary *movie = self.movies[indexPath.row];
	
	NSLog(@"Title : %@", movie[@"title"]);
	
	cell.titleLabel.text = movie[@"title"];
	cell.synopsisLabel.text = movie[@"synopsis"];
	NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
	[cell.posterView setImageWithURL:[NSURL URLWithString:url]];
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	MovieDetailViewController *vc = [[MovieDetailViewController alloc] init];
	vc.movie = self.movies[indexPath.row];
	[self.navigationController pushViewController:vc animated:YES];
}

CGFloat statusBarHeight()
{
	CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
	return MIN(statusBarSize.width, statusBarSize.height);
}
@end
