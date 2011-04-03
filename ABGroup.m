/*
 * ABGroup.m
 * iPhoneContacts
 * 
 * Created by Jim Dovey on 6/6/2009.
 * 
 * Copyright (c) 2009 Jim Dovey
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 * 
 * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * Neither the name of the project's author nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 * TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */


#import "ABGroup.h"
#import "ABPerson.h"
#import "ABSource.h"

extern NSArray * WrappedArrayOfRecords( NSArray * records, Class<ABRefInitialization> class );

@implementation ABGroup

- (id) init
{
    ABRecordRef group = ABGroupCreate();
    if ( group == NULL )
    {
        [self release];
        return ( nil );
    }
    
    return ( [self initWithABRef: group] );
}

- (ABSource *) source
{
	ABRecordRef source = ABGroupCopySource( _ref );
	return ( [[[ABSource alloc] initWithABRef: source] autorelease] );
}

- (NSArray *) allMembers
{
    NSArray * members = (NSArray *) ABGroupCopyArrayOfAllMembers( _ref );
    if ( [members count] == 0 )
    {
        [members release];
        return ( nil );
    }
    
    NSArray * result = (NSArray *) WrappedArrayOfRecords( members, [ABPerson class] );
    [members release];
    
    return ( result );
}

- (NSArray *) allMembersSortedInOrder: (ABPersonSortOrdering) order
{
    NSArray * members = (NSArray *) ABGroupCopyArrayOfAllMembersWithSortOrdering( _ref, order );
    if ( [members count] == 0 )
    {
        [members release];
        return ( nil );
    }
    
    NSArray * result = (NSArray *) WrappedArrayOfRecords( members, [ABPerson class] );
    [members release];
    
    return ( result );
}

- (BOOL) addMember: (ABPerson *) person error: (NSError **) error
{
    return ( (BOOL) ABGroupAddMember(_ref, person.recordRef, (CFErrorRef *)error) );
}

- (BOOL) removeMember: (ABPerson *) person error: (NSError **) error
{
    return ( (BOOL) ABGroupRemoveMember(_ref, person.recordRef, (CFErrorRef *)error) );
}

- (NSIndexSet *) indexSetWithAllMemberRecordIDs
{
    NSArray * members = (NSArray *) ABGroupCopyArrayOfAllMembers( _ref );
    if ( [members count] == 0 )
    {
        [members release];
        return ( nil );
    }
    
    NSMutableIndexSet * mutable = [[NSMutableIndexSet alloc] init];
    for ( id person in members )
    {
        [mutable addIndex: (NSUInteger)ABRecordGetRecordID((ABRecordRef)person)];
    }
    
    [members release];
    
    NSIndexSet * result = [mutable copy];
    [mutable release];
    
    return ( [result autorelease] );
}

@end
