//
//  NSStringTests.m
//  Kiwi
//
//  Created by Cristian Kocza on 02/04/14.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSString+KiwiAdditions.h"

@interface NSStringTest : SenTestCase

@end

@implementation NSStringTest

- (void)testMethodFamilyExactString{
    STAssertTrue([@"alloc" belongsToMethodFamily:@"alloc"],@"");
}

- (void)testMethodFamilyExactStringBeginningWithUnderscores{
    STAssertTrue([@"__alloc" belongsToMethodFamily:@"alloc"],@"");
}

- (void)testMethodFamilyExactStringEndingWithUnderscores{
    STAssertTrue([@"alloc___" belongsToMethodFamily:@"alloc"],@"");
}

- (void)testMethodFamilyExactStringBeginningAndEndingWithUnderscores{
    STAssertTrue([@"_alloc___" belongsToMethodFamily:@"alloc"],@"");
}

- (void)testMethodFamilyPartialString{
    STAssertTrue([@"allocObject" belongsToMethodFamily:@"alloc"],@"");
}

- (void)testMethodFamilyPartialStringBeginningWithUnderscores{
    STAssertTrue([@"__allocObject" belongsToMethodFamily:@"alloc"],@"");
}

- (void)testMethodFamilyExactStringWithParams{
    STAssertTrue([@"alloc:" belongsToMethodFamily:@"alloc"],@"");
}

- (void)testMethodIncorrectString{
    STAssertFalse([@"new" belongsToMethodFamily:@"alloc"],@"");
}

- (void)testMethodIncorrectStringBeginningWithUnderscores{
    STAssertFalse([@"____new" belongsToMethodFamily:@"alloc"],@"");
}


- (void)testMethodFamilySubtringButIncorrect{
    STAssertFalse([@"allocate" belongsToMethodFamily:@"alloc"],@"");
}

- (void)testClangDocExample1{
    STAssertTrue([@"_perform:with:" belongsToMethodFamily:@"perform"],@"");
}

- (void)testClangDocExample2{
    STAssertTrue([@"performWith:" belongsToMethodFamily:@"perform"],@"");
}

- (void)testClangDocExample3{
    STAssertFalse([@"performing:with" belongsToMethodFamily:@"perform"],@"");
}
@end
