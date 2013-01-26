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
      json = NSJSONSerialization.JSONObjectWithData(MSResult.dataFromBase64URLString(@msSDKResult.getValue), options:options, error:error_ptr)
      error = error_ptr[0]
      error.nil? ? json : decodeImageBase64URLString
    end

  private

    def decodeImageBase64URLString
      NSString.alloc.initWithData(MSResult.dataFromBase64URLString(@msSDKResult.getValue), encoding:NSUTF8StringEncoding)
    end

  end

end