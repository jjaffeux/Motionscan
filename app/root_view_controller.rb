class RootViewController < UIViewController

  attr_accessor :counterLabel

  def loadView
    super
    self.counterLabel = UILabel.alloc.initWithFrame([[60,80],[200,40]])
    self.counterLabel.textAlignment = UITextAlignmentCenter
    self.counterLabel.backgroundColor = UIColor.darkGrayColor
    self.counterLabel.font = UIFont.boldSystemFontOfSize(20)
    self.counterLabel.layer.cornerRadius = 5.0
    self.counterLabel.text = "Sync will start"
    self.view.addSubview(self.counterLabel)
  end

  def viewDidLoad
    super
    self.title = "Root"
    self.view.backgroundColor = UIColor.whiteColor

    @sync = Motionscan::Sync.init
    @sync.startWithStatus(
      lambda {
        NSLog("sync started")
      },
      success:lambda {|result|
        self.counterLabel.removeFromSuperview
        addFullFeaturedExampleScannerViewControllerButton
        addAnimatedExampleScannerViewControllerButton
      },
      error:lambda {|error|
        p error
      },
      progress:lambda {|progress, total|
        self.counterLabel.text = "#{progress} / #{total}"
      }
    )
  end

private

  def addFullFeaturedExampleScannerViewControllerButton
    scanButton = UIButton.buttonWithType(UIButtonTypeCustom)
    scanButton.frame = [[40,80],[240,40]]
    scanButton.setTitle("Launch Full Scanner", forState:UIControlStateNormal)
    scanButton.backgroundColor = UIColor.darkGrayColor
    scanButton.addTarget(self,
      action: :pushFullFeaturedExampleScannerViewController,
      forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(scanButton)
  end

  def addAnimatedExampleScannerViewControllerButton
    scanButton = UIButton.buttonWithType(UIButtonTypeCustom)
    scanButton.frame = [[40,140],[240,40]]
    scanButton.setTitle("Launch Animated Scanner", forState:UIControlStateNormal)
    scanButton.backgroundColor = UIColor.darkGrayColor
    scanButton.addTarget(self,
      action: :pushAnimatedExampleScannerViewController,
      forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(scanButton)
  end

  def pushFullFeaturedExampleScannerViewController
    scannerController = FullFeaturedScannerViewController.alloc.init
    self.navigationController.pushViewController(scannerController, animated:true)
  end

  def pushAnimatedExampleScannerViewController
    scannerController = AnimatedScannerViewController.alloc.init
    self.navigationController.pushViewController(scannerController, animated:true)
  end

end