Simple BDD for iOS
------------------
Kiwi is a Behavior Driven Development library for iOS development.
The goal is to provide a BDD library that is exquisitely simple to setup and use.

Ping me at @alding and let me know what you are using Kiwi for.

Requirements:
Xcode 4.x
LLVM compiler recommended.


Why?
----
- I enjoy using RSpec.
- I didn't enjoy the built in testing framework for Xcode as much.
- I feel that tests/specs that look like this are more readable:

describe(@"Team", ^{
    context(@"when newly created", ^{
        it(@"should have a name", ^{
            id team = [Team team];
            [[team.name should] equal:@"Black Hawks"];
        });
        
        it(@"should have 11 players", ^{
            id team = [Team team];
            [[[team should] have:11] players];
        });
    });
});

- I might be wrong :)


License
-------
Kiwi is open source software. You may freely distribute it under the terms of
the license agreement found in License.txt.


Contributing
------------
Pull requests welcome. Significant contributors are listed in Contributors.txt.


Getting it
----------
The best way to get Kiwi is by cloning the git repository: git clone git://github.com/allending/Kiwi.git


Project structure
-----------------
Kiwi.xcodeproject has two runnable targets: Kiwi and KiwiExamples. Both of these targets are set up to be Test targets.

To run tests in Xcode 4, run Product->Test, or use the Cmd-U shortcut.

- Running tests when Kiwi is the current target runs the SenTestKit tests used to test Kiwi the internals itself. The tests are located in the Tests group in the Xcode project navigator.
- Running tests when KiwiExamples is the current target runs the example Kiwi specs meant to serve as sample Kiwi usage. The specs are located in the Examples group in the Xcode project navigator.


Using it in your project
------------------------
The essential point to understand about using Kiwi in your own project is that:
- You have to first have a test target.
- The Kiwi library code has to be added to your test target.
- Tests are run in the same way regular Xcode tests are run: Perform the 'Test' action on the test target.

It is highly recommended (and probably a future requirement) that you set the compiler for the test target to the latest version of the LLVM compiler. It is also easy to set up Kiwi as a static library or separate project within a workspace. Instructions will come when I have time.

Example scenarios are provided below for the simplest use cases.


For a new Xcode project
-----------------------
1. Create a new iOS project (we will use Foobar as a sample project name) and ensure that "Include Unit Tests" is selected during the new project wizard process. This should result in a Tests group in your new project. You should also have a test target named something like FoobarTests.

2. Remove the sample FoobarTest.(h|m) files Xcode generated. 

3. Add all the Kiwi sources (.h and .m) to your test target. The files are located in the Kiwi/Kiwi directory you cloned with git. Just to be clear, this is the directory that contains the Kiwi.h file. An easy way to do this is to add the entire Kiwi directory with Xcode with the options "Copy items into destination group's folder" and the "Add to target: FoobarTests ".

4. Add a new FoobarSpec.m file to the test target, and make sure that it belongs to the FoobarTests test target. You can use the contents of FoobarSpec.m below.

5. Run the FoobarTests test target (Product->Test or Cmd-U). The spec should run. Try changing 'should' to 'shouldNot' in the spec and rerun the test. You should now see a test failure.

6. Start adding your own specs.


For an existing project with an existing test target
----------------------------------------------------
1. Start from step (3) in the instructions given above for "For a new Xcode project".


For an existing project without a test target
---------------------------------------------
1. Add a new Cocoa Touch Unit Testing Bundle to your project (File->New->New Target...->Other).
2. Continue from step (3) in the instructions given above for "For a new Xcode project".


//
// FoobarSpec.m
//

#import "Kiwi.h"

SPEC_BEGIN(FoobarSpec)

describe(@"Foobar", ^{
    it(@"a simple test", ^{
        NSString *greeting = [NSString stringWithFormat:@"%@ %@", @"Hello", @"world"];
        [[greeting should] equal:@"Hello world"];
    });
});

SPEC_END
