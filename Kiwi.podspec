Pod::Spec.new do |s|

  s.name            = 'Kiwi'
  s.version         = '3.0.0'
  s.summary         = 'A Behavior Driven Development library for iOS and OS X.'
  s.homepage        = 'https://github.com/kiwi-bdd/Kiwi'
  s.source          = { :git => 'https://github.com/kiwi-bdd/Kiwi.git', :tag => "v#{s.version}" }
  s.license         = { :type => 'MIT', :file => 'License.txt' }

  s.authors = {
    'Allen Ding'       => 'alding@gmail.com',
    'Luke Redpath'     => 'luke@lukeredpath.co.uk',
    'Marin Usalj'      => 'marin2211@gmail.com',
    'Stepan Hruda'     => 'stepan.hruda@gmail.com',
    'Brian Gesiak'     => 'modocache@gmail.com',
    'Adam Sharp'       => 'adsharp@me.com',
    'Eduardo Caselles' => 'edu@casell.es'
  }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.8'

  s.framework = 'XCTest'
  s.source_files = 'Classes/**/*.{h,m}'
  s.requires_arc = true
  s.prefix_header_contents = '#import <XCTest/XCTest.h>'

end
