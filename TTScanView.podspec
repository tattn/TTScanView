Pod::Spec.new do |s|

  s.name         = "TTScanView"
  s.version      = "0.0.1"
  s.summary      = "A library which shows/reads QR code or barcode easily"

  s.homepage     = "https://github.com/tattn/TTScanView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Tatsuya Tanaka" => "tatsuyars@yahoo.co.jp" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/tattn/TTScanView.git", :tag => "v#{s.version}" }
  s.source_files  = "TTScanView/TTScanView/*.{swift,h}"
  s.public_header_files = "TTScanView/TTScanView/TTScanView.h"

  s.frameworks   = 'UIKit', 'Foundation'
  s.requires_arc = true
end
