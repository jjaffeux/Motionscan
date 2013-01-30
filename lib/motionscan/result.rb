module Motionscan

  class Result

    def initialize(msSDKResult)
      @msSDKResult = msSDKResult
    end

    def imageId
      @msSDKResult.getValue
    end

    def data
      error_ptr = Pointer.new(:object)

      options = NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
      json = NSJSONSerialization.JSONObjectWithData(base64URLString,
        options:options,
        error:error_ptr)

      error = error_ptr[0]
      error.nil? ? json : decodeImageBase64URLString
    end

  private

    def decodeImageBase64URLString
      NSString.alloc.initWithData(base64URLString, encoding:NSUTF8StringEncoding)
    end

    def base64URLString
      MSResult.dataFromBase64URLString(@msSDKResult.getValue)
    end

  end

end