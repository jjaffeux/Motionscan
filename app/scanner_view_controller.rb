class ScannerViewController < UIViewController

  def init
    super
    @overlay = UILabel.alloc.initWithFrame([[10,10],[300,40]])
    @overlay.textAlignment = UITextAlignmentCenter
    @overlay.alpha = 0.8
    @overlay.backgroundColor = UIColor.darkGrayColor
    @overlay.layer.zPosition = 2
    self.view.addSubview(@overlay)
    self
  end

  def viewDidAppear(animated)
    @scanner = Motionscan::Scanner.initWithFrame(self.view.bounds)
    @scanner.displayScannerInView(self.view)
    @scanner.startWithStatus(
      lambda {
        @overlay.text = "Will start scanning"
      },
      success:lambda {|result|
        @overlay.text = "#{result.data[:type]}"
      },
      error:lambda {|error|},
      notFound:lambda {}
    )
  end

  def viewWillDisappear(animated)
    @scanner.stop
  end

end