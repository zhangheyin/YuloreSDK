
/*
     File: SectionInfo.h
 Abstract: A section info object maintains information about a section:
 * Whether the section is open
 * The header view for the section
 * The model objects for the section -- in this case, the dictionary containing the quotations for a single play
 * The height of each row in the section
 
  Version: 2.0
  
 */

#import <Foundation/Foundation.h>

@class SectionHeaderView;
//@class Play;

@interface Play : NSObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *quotations;

@end

@interface SectionInfo : NSObject 
@property (retain) SectionHeaderView* headerView;

@property (retain) Play* play;
@property (assign) BOOL open;
@end
