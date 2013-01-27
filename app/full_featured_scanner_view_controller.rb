class FullFeaturedScannerViewController < UIViewController

  def viewDidAppear(animated)
    @scanner = Motionscan::Scanner.initWithFrame(self.view.bounds)
    @scanner.displayScannerInView(self.view)
    @scanner.startWithStatus(
      lambda {
        p "started"
      },
      success:lambda {|result|
        p result
      },
      error:lambda {|error|
        p error
      },
      notFound:lambda {
        p "not found"
      }
    )
  end

  def userDidPressSnapButton
    @scanner.snapWithStatus(
      lambda {
        p "started"
      },
      success:lambda {|result|
        p result
      },
      error:lambda {|error|
        p error
      },
      notFound:lambda {
        p "not found"
      }
    )
  end

  def viewWillDisappear(animated)
    @scanner.stop
  end

end