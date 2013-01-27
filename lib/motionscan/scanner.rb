module Motionscan
	class Scanner
    include Flash

    attr_accessor :view
    attr_accessor :flashEnabled
    attr_accessor :session
    attr_accessor :result
    attr_accessor :frame

    def self.initWithFrame(frame)
      instance = allocate
      instance.scannerInitializer(frame)
      instance
    end

    def scannerInitializer(frame)
      @frame = frame
      @flashEnabled = true
      @view = UIView.alloc.initWithFrame(frame)
      @result = nil
    end

    def frame=(frame)
      @view.frame = frame
    end

    def displayScannerInView(view)
      @session = MSScannerSession.alloc.initWithScanner(MSScanner.sharedInstance)
      @session.scanOptions = MS_RESULT_TYPE_IMAGE
      @session.delegate = self

      @view.backgroundColor = UIColor.blackColor
      @view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      @view.autoresizesSubviews = true
      view.addSubview(@view)
    end

    # scanner session flow
    def startWithStatus(scanStarted, success:scanCompleted, 
      error:scanError, notFound:scanNotFound)
      scanStarted.call
      @scanCompleted = scanCompleted
      @scanError = scanError
      @scanNotFound = scanNotFound

      viewLayer = @view.layer
      viewLayer.setMasksToBounds(true)

      captureLayer = @session.previewLayer
      captureLayer.setFrame(@view.bounds)
      
      viewLayer.insertSublayer(captureLayer, below:viewLayer.sublayers)

      @session.startCapture
    end

    def stop
      @session.stopCapture
      @session.cancel
      @view.removeFromSuperview
    end

    def resume
      @session.resume
    end

    def snapWithStatus(searchStarted, success:searchCompleted,error:searchError,notFound:searchNotFound)
      @searchStarted = searchStarted
      @searchCompleted = searchCompleted
      @searchError = searchError
      @searchNotFound = searchNotFound

      @flash if @flashEnabled
      @session.snap
      @session.pause
    end

    # delegates
    def session(session, didScan:result)
      Dispatch::Queue.main.async { 
        result.nil? ? @scanNotFound.call : @scanCompleted.call(Result.new(result))
      }
    end

    def session(session, failedToScan:error)
      Dispatch::Queue.main.async { @scanError.call(error) }
    end

    def scannerWillSearch(scanner)
      Dispatch::Queue.main.async { @searchStarted.call }
    end

    def scanner(scanner, didSearchWithResult:result)
      Dispatch::Queue.main.async { 
        result.nil? ? @searchNotFound.call : @searchCompleted.call(Result.new(result))
      }
    end

    def scanner(scanner, failedToSearchWithError:error)
      Dispatch::Queue.main.async { @searchError.call(error) }
    end

    def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
      interfaceOrientation == UIInterfaceOrientationPortrait
    end

	end
end