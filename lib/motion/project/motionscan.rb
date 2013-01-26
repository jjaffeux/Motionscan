unless defined?(Motion::Project::Config)
	raise "This file must be required within a RubyMotion project Rakefile."
end

class MotionscanConfig
	attr_accessor :api_key
	attr_accessor :api_secret

	def initialize(config)
		@config = config
	end

	def api_secret=(api_secret)
		@api_secret = api_secret
		create_code
	end

private

	def create_code
		unless @api_key && @api_secret
			raise "Need to configure `app.motionscan.api_key' and `app.motionscan.api_secret' variables"
		end

		code = <<EOF
# Moodstocks SDK launcher
# This file is automatically generated. Do not edit.
if MSDeviceCompatibleWithSDK()
	scanner = MSScanner.sharedInstance
	error_ptr = Pointer.new(:object)
	unless scanner.openWithKey("#{@api_key}", secret:"#{@api_secret}", error:error_ptr)
		errorCode = error_ptr[0].code
		if errorCode == MS_CREDMISMATCH
			NSLog("[MOODSTOCKS SDK] There is a problem with your key/secret pair : see https://github.com/Moodstocks/moodstocks-sdk/blob/master/sample/iphone/demo/Demo/MSAppDelegate.m#L65")
			NSException.exceptionWithName("MSScannerException", reason:"Credentials mismatch", userInfo:nil).raise
		else
			errorString = NSString.stringWithCString(ms_errmsg(errorCode), encoding:NSUTF8StringEncoding)
			NSLog("[MOODSTOCKS SDK] Scanner open error code :" + errorString)
		end
	end
	NSLog("[MOODSTOCKS SDK] Scanner started.")
else
	NSLog("[MOODSTOCKS SDK] Your device is not compatible with the Moodstocks SDK.")
end
EOF

		motionscan_file = './app/motionscan_config.rb'
		create_stub(motionscan_file, code)
		add_file(motionscan_file)
	end

	def create_stub(path, code)
		if !File.exist?(path) or File.read(path) != code
			File.open(path, 'w') { |io| io.write(code) }
		end
	end

	def add_file(path)
		files = @config.files.flatten
		@config.files << path unless files.find { |x| File.expand_path(x) == File.expand_path(path) }
	end
end

module Motion
	module Project
		class Config

			variable :motionscan

			def motionscan
				@motionscan ||= MotionscanConfig.new(self)
				yield @motionscan if block_given?
				@motionscan
			end

		end
	end
end