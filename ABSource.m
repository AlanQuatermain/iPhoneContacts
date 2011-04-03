//
//  ABSource.m
//  iPhoneContacts
//
//  Created by David Beck on 4/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ABSource.h"

#import "ABAddressBook.h"
#import "ABGroup.h"

extern NSArray * WrappedArrayOfRecords( NSArray * records, Class<ABRefInitialization> class );


@implementation ABSource

- (NSArray *) allGroups
{
	NSArray * groups = (NSArray *) ABAddressBookCopyArrayOfAllGroupsInSource( [ABAddressBook sharedAddressBook].addressBookRef, _ref );
    if ( [groups count] == 0 )
    {
        [groups release];
        return ( nil );
    }
    
    NSArray * result = (NSArray *) WrappedArrayOfRecords( groups, [ABGroup class] );
    [groups release];
    
    return ( result );
}

@end
