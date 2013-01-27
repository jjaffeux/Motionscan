module Motionscan
	class ScannerViewController < UIViewController
    include Flash

    attr_accessor :scannerView
    attr_accessor :delegate
    attr_accessor :flashEnabled    
    attr_accessor :session
    attr_accessor :result
    attr_accessor :overlay

    def initWithNibName(nibNameOrNil, bundle:nibBundleOrNil)
      super
      self.overlay = OverlayView.alloc.init
      self.overlay.scanner = self
      self.delegate = self
      self.flashEnabled = true
      self.scannerView = ScannerView.alloc.init
      self.result = nil
      self
    end

    def loadView
      super
      self.session = MSScannerSession.alloc.initWithScanner(MSScanner.sharedInstance)
      self.session.scanOptions = MS_RESULT_TYPE_IMAGE
      self.session.delegate = self

      self.scannerView.frame = [[0, 0],self.view.frame[1]]
      self.scannerView.backgroundColor = UIColor.blackColor
      self.scannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      self.scannerView.autoresizesSubviews = true
      self.view.addSubview(self.scannerView)

      self.view.when_tapped { snap }
    end

    def viewDidLoad
      super
      scannerViewLayer = self.scannerView.layer
      scannerViewLayer.setMasksToBounds(true)

      captureLayer = self.session.previewLayer
      captureLayer.setFrame(self.scannerView.bounds)
      
      scannerViewLayer.insertSublayer(captureLayer, below:scannerViewLayer.sublayers)

      self.session.startCapture
    end

    def viewWillDisappear(animated)
      super
      self.session.stopCapture
      self.session.cancel
    end

    def snap
      self.flash if self.flashEnabled
      self.session.snap
      self.session.pause
    end

    def session(session, didScan:result)
      if self.result.nil? and !result.nil?
        self.result = result
        self.overlay.session(session, didScanWithResult:Result.new(result))
      else
        self.overlay.sessionDidScanWithoutResult(session)
      end
    end

    def session(session, failedToScan:error)
      self.overlay.session(session, didScan:error)
    end

    def scannerWillSearch(scanner)
      self.overlay.scannerWillSearch(scanner)
    end

    def scanner(scanner, didSearchWithResult:result)
      self.overlay.scanner(scanner, didSearchWithResult:Result.new(result))
    end

    def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
      interfaceOrientation == UIInterfaceOrientationPortrait
    end

    def resume
      self.result = nil
      self.session.resume
    end

	end
end