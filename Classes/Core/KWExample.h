//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWBlock.h"
#import "KWVerifying.h"
#import "KWExpectationType.h"
#import "KWExampleNode.h"
#import "KWExampleNodeVisitor.h"
#import "KWReporting.h"
#import "KWExampleDelegate.h"

@class KWCallSite;
@class KWExampleSuite;
@class KWContextNode;
@class KWSpec;
@class KWMatcherFactory;

@interface KWExample : NSObject <KWExampleNodeVisitor, KWReporting>

@property (nonatomic, strong, readonly) NSMutableArray *lastInContexts;
@property (nonatomic, weak) KWExampleSuite *suite;
@property (nonatomic, strong) id<KWVerifying> unresolvedVerifier;


- (id)initWithExampleNode:(id<KWExampleNode>)node;

#pragma mark - Adding Verifiers

- (id)addVerifier:(id<KWVerifying>)aVerifier;
- (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout shouldWait:(BOOL)shouldWait;

#pragma mark - Report failure

- (void)reportFailure:(KWFailure *)failure;

#pragma mark - Running

- (void)runWithDelegate:(id<KWExampleDelegate>)delegate;

#pragma mark - Anonymous It Node Descriptions

- (NSString *)generateDescriptionForAnonymousItNode;

#pragma mark - Checking if last in context

- (BOOL)isLastInContext:(KWContextNode *)context;

#pragma mark - Full description with context

- (NSString *)descriptionWithContext;

@end

#pragma mark - Building Example Groups

void describe(NSString *aDescription, void (^block)(void));
void context(NSString *aDescription, void (^block)(void));
void registerMatchers(NSString *aNamespacePrefix);
void beforeAll(void (^block)(void));
void afterAll(void (^block)(void));
void beforeEach(void (^block)(void));
void afterEach(void (^block)(void));
void let_(id *anObjectRef, const char *aSymbolName, id (^block)(void));
void it(NSString *aDescription, void (^block)(void));
void specify(void (^block)(void));
void pending_(NSString *aDescription, void (^block)(void));

void describeWithCallSite(KWCallSite *aCallSite, NSString *aDescription, void (^block)(void));
void contextWithCallSite(KWCallSite *aCallSite, NSString *aDescription, void (^block)(void));
void registerMatchersWithCallSite(KWCallSite *aCallSite, NSString *aNamespacePrefix);
void beforeAllWithCallSite(KWCallSite *aCallSite, void (^block)(void));
void afterAllWithCallSite(KWCallSite *aCallSite, void (^block)(void));
void beforeEachWithCallSite(KWCallSite *aCallSite, void (^block)(void));
void afterEachWithCallSite(KWCallSite *aCallSite, void (^block)(void));
void letWithCallSite(KWCallSite *aCallSite, id *anObjectRef, NSString *aSymbolName, id (^block)(void));
void itWithCallSite(KWCallSite *aCallSite, NSString *aDescription, void (^block)(void));
void pendingWithCallSite(KWCallSite *aCallSite, NSString *aDescription, void (^block)(void));

// This function declaration is solely meant to coax Xcode into exposing
// the let() function defined in the macro below during autocompletion.
// The macro then just calls into the real function, let_().
void let(id name, id (^block)(void));

// The let macro needs to:
//
//   a) Declare a local variable, and
//   b) Get a pointer to the local variable that can later be
//      dereferenced and assigned the return value of the block
//
// However, by the time an example block is executed, any references to
// __block variables will have been copied to the heap:
//
//    __block id foo = nil;
//    void (^bar)(void) = ^{
//      foo; // (1)
//    };
//    specify(^{
//      foo; // (2)
//    });
//
// Thus, though (1) and (2) both resolve to the same variable, a
// pointer to (1) will have a different address than a pointer to (2),
// because the first is on the stack and the second on the heap.
//
// This means that if we dereference a pointer to (1), we get a different
// location in memory than if we dereference a pointer to (2). For the
// eager evaluation of let nodes to work, we need a *non-stack pointer*.
//
// How do we get a pointer at position (1) that points to the same
// location as position (2)? We need to return the pointer from a block
// that has been copied to the heap, like so:
//
//    __autoreleasing id *fooRef = Block_copy(^{
//        // capture a reference to foo; get a pointer to the heap location
//        __autoreleasing id *fooRef = &foo;
//        return fooRef;
//    })();
//
// Every reference to 'foo' from within a block that has been copied to
// the heap points to the same location in memory, so by copying this
// block and returning a pointer, we have a pointer to the same variable
// that is referenced within the example node.
//
// The reason we don't return '&foo' directly, e.g.,
//
//    Block_copy(^{ return &foo; })();
//
// is that clang will generate the warning "Address of stack memory
// associated local variable '...' returned". As it turns out, this is
// actually the desired behaviour. So to keep the compiler happy, we add
// the indirection of first assigning to a local id * variable, then
// returning that pointer.
//
// This ultimately allows us to pass around pointers to block storage
// that resides on the heap.
//
#define let(var, args...) \
    __block id var = nil; \
    let_( \
        Block_copy(^{ __autoreleasing id *ref = &var; return ref; })(), \
        #var, \
        ## args\
    )

#define PRAGMA(x) _Pragma (#x)
#define PENDING(x) PRAGMA(message ( "Pending: " #x ))

#define pending(title, args...) \
PENDING(title) \
pending_(title, ## args)
#define xit(title, args...) \
PENDING(title) \
pending_(title, ## args)
