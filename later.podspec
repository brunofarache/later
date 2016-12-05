Pod::Spec.new do |s|
	s.name					= "later"
	s.version				= "0.2.0"
	s.summary				= "Just another Promise library for Swift."
	s.homepage				= "https://github.com/brunofarache/later"
	s.license				= "MIT"
	s.author				= {
								"Bruno Farache" => "bruno.farache@liferay.com",
								"Victor Galán" => "victor.galan@liferay.com"
							}
	s.platform				= :ios
	s.ios.deployment_target	= '8.0'
	s.source				= {
								:git => "https://github.com/brunofarache/later.git",
								:tag => s.version.to_s
							}
	s.source_files			= "Source/**/*.swift"
end