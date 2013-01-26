module Motionscan
	class ScannerViewController < UIViewController

    attr_accessor :scannerView
    attr_accessor :delegate
    attr_accessor :flashEnabled
    attr_accessor :overlay
    attr_accessor :session
    attr_accessor :result

    def initWithNibName(nibNameOrNil, bundle:nibBundleOrNil)
      super

      self.overlay = OverlayView.alloc.init
      self.delegate = self
      self.flashEnabled = true
      self.scannerView = ScannerView.alloc.init

      self.session = MSScannerSession.alloc.initWithScanner(MSScanner.sharedInstance)
      self.session.scanOptions = MS_RESULT_TYPE_IMAGE
      self.session.delegate = self

      self.result = nil

      self
    end

    def loadView
      super
      self.scannerView.frame = [[0, 0],self.view.frame[1]]
      self.scannerView.backgroundColor = UIColor.blackColor
      self.scannerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight
      self.scannerView.autoresizesSubviews = true
      self.view.addSubview(self.scannerView)

      self.view.when_tapped { snapAction }
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

    def snapAction
      self.session.snap
      self.session.pause
    end

    def session(session, didScan:result)
      if self.result.nil?
        self.result = result
        updateOverlay(self.result)
      end
      #p "did scan"
    end

    def session(scanner, failedToScan:error)
      updateOverlay(error)
      p "failed to scan #{error}"
      #self.stopSpinner
      self.session.resume
    end

    def scannerWillSearch(scanner)
      updateOverlay
      p "will search"
    end

    def scanner(scanner, didSearchWithResult:result)
      updateOverlay(result)
      # self.stopSpinner
      # if result.nil?
      #   App.alert "Image not found"
      # else
      #   App.alert "Image found #{result.getValue}"
      # end
      p "didSearchWithResult"
      p "Image found #{result.getValue}" unless result.nil?
      self.session.resume
    end

    def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
      interfaceOrientation == UIInterfaceOrientationPortrait
    end

  private

    def updateOverlay(result)
      self.overlay.send(:update, self, result) unless self.overlay.nil?
    end

	end
end