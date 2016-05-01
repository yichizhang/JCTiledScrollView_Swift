Pod::Spec.new do |s|
  s.name             = "JCTiledScrollView_Swift"
  s.version          = "0.0.3"
  s.summary          = "Using UIScrollView CATiledLayer to display large images and PDFs at multiple zoom scales"
  s.description      = "Jesse Collis's JCTiledScrollView rewritten in Swift. A set of classes that wrap UIScrollView and CATiledLayer. It aims to simplify displaying large images and PDFs at multiple zoom scales."
  s.homepage         = "https://github.com/yichizhang/JCTiledScrollView_Swift"
  s.license          = 'MIT'
  s.author           = { "Yichi Zhang" => "zhang-yi-chi@hotmail.com" }
  s.source           = { :git => "https://github.com/yichizhang/JCTiledScrollView_Swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nsyichi'
  s.requires_arc = true
  s.source_files = 'JCTiledScrollView_Swift_Source/**/*'
  s.ios.deployment_target = '8.0'
end
