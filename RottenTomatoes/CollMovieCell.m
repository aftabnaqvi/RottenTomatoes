//
//  CollMovieCell.m
//  RottenTomatoes
//
//  Created by Syed Naqvi on 2/8/15.
//  Copyright (c) 2015 Naqvi. All rights reserved.
//

#import "CollMovieCell.h"

@implementation CollMovieCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	if (highlighted) {
		self.titleLabel.textColor = [UIColor purpleColor];
	} else {
		self.titleLabel.textColor = [UIColor blackColor];
	}
}
@end
