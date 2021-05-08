Pod::Spec.new do |s|

	s.name         = "ZYAlertViewController"
	s.version      = "1.0.2"
	s.summary      = "ZYAlertViewController."

	s.description  = <<-DESC
	this is ZYAlertViewController.
	DESC

	s.homepage     = "https://github.com/iDev01/ZYAlertViewController"
	s.license      = { :type => "MIT", :file => "LICENSE" }
	s.author             = { "iDev01" => "ideveloper_mahao@163.com" }
	s.platform = :ios, "12.2"
	s.ios.deployment_target = "9.0"
	s.requires_arc = true

	s.source_files = 'ZYAlertViewController/*.{h,m}'
	
	s.source = { :git => "https://github.com/iDev01/ZYAlertViewController.git", :tag => s.version }
  
end