/*
 * ABAddressBook.m
 * iPhoneContacts
 * 
 * Created by Jim Dovey on 5/6/2009.
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

#import <libkern/OSAtomic.h>

#import "ABAddressBook.h"
#import "ABPerson.h"
#import "ABGroup.h"
#import "ABSource.h"

NSString *ABAddressBookDidChangeNotification = @"ABAddressBookDidChange";

NSArray * WrappedArrayOfRecords( NSArray * records, Class<ABRefInitialization> wrapperClass )
{
    NSMutableArray * wrapped = [[NSMutableArray alloc] initWithCapacity: [records count]];
    for ( id record in records )
    {
        id obj = [[wrapperClass alloc] initWithABRef: (CFTypeRef)record];
        [wrapped addObject: obj];
        [obj release];
    }
    
    NSArray * result = [wrapped copy];
    [wrapped release];
    
    return ( [result autorelease] );
}

@interface ABAddressBook ()
- (void) _handleExternalChangeCallback;
@end

static void _ExternalChangeCallback( ABAddressBookRef bookRef, CFDictionaryRef info, void * context )
{
    ABAddressBook * obj = (ABAddressBook *) context;
    [obj _handleExternalChangeCallback];
}

@implementation ABAddressBook

@synthesize addressBookRef=_ref;

+ (ABAddressBook *) sharedAddressBook
{
    static ABAddressBook * volatile __shared = nil;
    
    if ( __shared == nil )
    {
        ABAddressBook * tmp = [[ABAddressBook alloc] init];
        if ( OSAtomicCompareAndSwapPtr(nil, tmp, (void * volatile *)&__shared) == false )
            [tmp release];
    }
    
    return ( __shared );
}

- (id) initWithABRef: (CFTypeRef) ref
{
    if ( ref == NULL )
    {
        [self release];
        return ( nil );
    }
    
    if ( [super init] == nil )
        return ( nil );
    
    // we can't to CFTypeID checking on AB types, so we have to trust the user
    _ref = (ABAddressBookRef) CFRetain(ref);
	
	ABAddressBookRegisterExternalChangeCallback( _ref, _ExternalChangeCallback, self );
    
    return ( self );
}

- (id) init
{
    ABAddressBookRef ref = ABAddressBookCreateWithOptions(NULL, NULL);
    
	self = [self initWithABRef:ref];
	
	CFRelease(ref);
    
    return ( self );
}

- (void) dealloc
{
    self.delegate = nil;
    if ( _ref != NULL )
        CFRelease( _ref );
    [super dealloc];
}

- (id<ABAddressBookDelegate>) delegate
{
    return ( _delegate );
}

- (void) setDelegate: (id<ABAddressBookDelegate>) delegate
{
    _delegate = delegate;
}

- (BOOL) save: (NSError **) error
{
	BOOL result = (BOOL) ABAddressBookSave(_ref, (CFErrorRef *)error);
	[[NSNotificationCenter defaultCenter] postNotificationName:ABAddressBookDidChangeNotification object:self];
    return ( result );
}

- (BOOL) hasUnsavedChanges
{
    return ( (BOOL) ABAddressBookHasUnsavedChanges(_ref) );
}

- (BOOL) addRecord: (ABRecord *) record error: (NSError **) error
{
    return ( (BOOL) ABAddressBookAddRecord(_ref, record.recordRef, (CFErrorRef *)error) );
}

- (BOOL) removeRecord: (ABRecord *) record error: (NSError **) error
{
    return ( (BOOL) ABAddressBookRemoveRecord(_ref, record.recordRef, (CFErrorRef *)error) );
}

- (NSString *) localizedStringForLabel: (NSString *) label
{
    NSString * str = (NSString *) ABAddressBookCopyLocalizedLabel( (CFStringRef)label );
    return ( [str autorelease] );
}

- (void) revert
{
    ABAddressBookRevert( _ref );
}

- (void) _handleExternalChangeCallback
{
    if(_delegate && [_delegate respondsToSelector:@selector(addressBookDidChange:)])
        [_delegate addressBookDidChange: self];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ABAddressBookDidChangeNotification object:self];
}

@end

@implementation ABAddressBook (People)

- (NSUInteger) personCount
{
    return ( (NSUInteger) ABAddressBookGetPersonCount(_ref) );
}

-(ABPerson *) personWithRecordRef:(ABRecordRef) recordRef
{
    return ( [[[ABPerson alloc] initWithABRef: recordRef] autorelease] );    
}

- (ABPerson *) personWithRecordID: (ABRecordID) recordID
{
    ABRecordRef person = ABAddressBookGetPersonWithRecordID( _ref, recordID );
    if ( person == NULL )
        return ( nil );
    
    return ( [[[ABPerson alloc] initWithABRef: person] autorelease] );
}

- (NSArray *) allPeople
{
    NSArray * people = (NSArray *) ABAddressBookCopyArrayOfAllPeople( _ref );
    if ( [people count] == 0 )
    {
        [people release];
        return ( nil );
    }
    
    NSArray * result = WrappedArrayOfRecords( people, [ABPerson class] );
    [people release];
    
    return ( result );
}

- (NSArray *) allPeopleSorted
{
  CFArrayRef people = ABAddressBookCopyArrayOfAllPeople( _ref );
  if ( CFArrayGetCount(people) == 0 )
  {
      CFRelease(people);
      return ( nil );
  }
  
  CFMutableArrayRef peopleMutable = CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                    CFArrayGetCount(people),
                                    people
                                    );
  CFRelease(people);
  CFArraySortValues(
            peopleMutable,
            CFRangeMake(0, CFArrayGetCount(peopleMutable)),
            (CFComparatorFunction) ABPersonComparePeopleByName,
            (void*) ABPersonGetSortOrdering()
            );

  NSArray *peopleSorted = (NSArray*)peopleMutable;
  NSArray *result = WrappedArrayOfRecords( peopleSorted, [ABPerson class] );
  [peopleSorted release];

  return ( result );
}

- (NSArray *) allPeopleWithName: (NSString *) name
{
    NSArray * people = (NSArray *) ABAddressBookCopyPeopleWithName( _ref, (CFStringRef)name );
    if ( [people count] == 0 )
    {
        [people release];
        return ( nil );
    }
    
    NSArray * result = WrappedArrayOfRecords( people, [ABPerson class] );
    [people release];
    
    return ( result );
}

@end

@implementation ABAddressBook (Groups)

- (NSUInteger) groupCount
{
    return ( (NSUInteger) ABAddressBookGetGroupCount(_ref) );
}

- (ABGroup *) groupWithRecordID: (ABRecordID) recordID
{
    ABRecordRef group = ABAddressBookGetGroupWithRecordID( _ref, recordID );
    if ( group == NULL )
        return ( nil );
    
    return ( [[[ABGroup alloc] initWithABRef: group] autorelease] );
}

- (NSArray *) allGroups
{
    NSArray * groups = (NSArray *) ABAddressBookCopyArrayOfAllGroups( _ref );
    if ( [groups count] == 0 )
    {
        [groups release];
        return ( nil );
    }
    
    NSArray * result = WrappedArrayOfRecords( groups, [ABGroup class] );
    [groups release];
    
    return ( result );
}

@end

@implementation ABAddressBook (Sources)

- (ABSource *) sourceWithRecordID: (ABRecordID) recordID
{
	ABRecordRef source = ABAddressBookGetSourceWithRecordID( _ref, recordID );
    if ( source == NULL )
        return ( nil );
    
    return ( [[[ABSource alloc] initWithABRef: source] autorelease] );
}

- (ABSource *) defaultSource
{
	ABRecordRef source = ABAddressBookCopyDefaultSource( _ref );
	if ( source == NULL )
        return ( nil );
    
    return ( [[[ABSource alloc] initWithABRef: source] autorelease] );
}

- (NSArray *) allSources
{
	NSArray * sources = (NSArray *) ABAddressBookCopyArrayOfAllSources( _ref );
    if ( [sources count] == 0 )
    {
        [sources release];
        return ( nil );
    }
    
    NSArray * result = WrappedArrayOfRecords( sources, [ABSource class] );
    [sources release];
    
    return ( result );
}

@end
