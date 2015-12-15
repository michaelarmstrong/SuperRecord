# One Day this will work...
Pod::Spec.new do |s|
  s.name         = "SuperRecord"
  s.version      = "1.6"
  s.summary      = "A Swift CoreData extension to bring some love and take the hassle out of common CoreData tasks."
  s.homepage     = "http://superarmstrong.uk"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = "Michael Armstrong"
  s.source       = { 
    :git => "https://github.com/michaelarmstrong/SuperRecord.git",
	:tag => s.version,
    :branch => 'master'
  }


  s.ios.deployment_target = '8.0'
  s.watchos.deployment_target = '2.0'
  s.source_files = 'SuperRecord/*.swift'
  s.requires_arc = true
end
