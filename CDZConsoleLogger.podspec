Pod::Spec.new do |s|
  s.name         = "CDZConsoleLogger"
  s.version      = "1.0.0"
  s.summary      = "A beautiful logger on the phone at debug"
  s.homepage     = "https://github.com/Nemocdz/CDZConsoleLogger"
  s.license      = "MIT"
  s.authors      = { 'Nemocdz' => 'nemocdz@gmail.com'}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Nemocdz/CDZConsoleLogger.git", :tag => s.version }
  s.source_files = 'CDZConsoleLogger', 'CDZConsoleLoggerDemo/CDZConsoleLogger/*.{h,m}'
  s.requires_arc = true
end
