
/*
     File: Quotation.h
 Abstract: A simple model class to represent a quotation with information about the character, and the act and scene in which the quotation was made.
 
  Version: 2.0
 */

#import <Foundation/Foundation.h>


@interface Quotation : NSObject 

@property (nonatomic, retain) NSString *character;
@property (nonatomic, retain) NSString *identity;
//@property (nonatomic, assign) NSInteger act;
//@property (nonatomic, assign) NSInteger scene;
//@property (nonatomic, strong) NSString *quotation;

@end
