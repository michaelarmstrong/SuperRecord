# One Day this will work...
Pod::Spec.new do |s|
  s.name         = "SuperRecord"
  s.version      = "1.0"
  s.summary      = "A Swift CoreData extension to bring some love and take the hassle out of common CoreData tasks."
  s.homepage     = "http://superarmstrong.uk"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = "Michael Armstrong"
  s.source       = { 
    :git => "https://github.com/michaelarmstrong/SuperRecord.git",
    :branch => 'master'
  }

  s.platform     = :ios, '7.0'
  s.source_files = '*.swift'
  s.requires_arc = true
end
