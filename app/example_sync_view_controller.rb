class ExampleSyncViewController < Motionscan::SyncViewController

  attr_accessor :counterLabel

  def loadView
    super
    self.counterLabel = UILabel.alloc.initWithFrame([[60,80],[200,40]])
    self.counterLabel.textAlignment = UITextAlignmentCenter
    self.counterLabel.backgroundColor = UIColor.darkGrayColor
    self.counterLabel.font = UIFont.boldSystemFontOfSize(30)
    self.counterLabel.layer.cornerRadius = 5.0
    self.view.addSubview(self.counterLabel)
  end

  def viewDidLoad
    super
    self.title = "ExampleSyncViewController"
    self.view.backgroundColor = UIColor.whiteColor
  end

  def didSyncWithProgress(progress, total:total)
    super
    self.counterLabel.text = "#{progress} / #{total}"
  end

  def scannerDidSync(scanner)
    super
    self.counterLabel.removeFromSuperview
    scanButton = UIButton.buttonWithType(UIButtonTypeCustom)
    scanButton.frame = [[60,80],[200,40]]
    scanButton.setTitle("Launch Scanner", forState:UIControlStateNormal)
    scanButton.backgroundColor = UIColor.darkGrayColor
    scanButton.addTarget(self,
      action: :pushExampleScannerViewController,
      forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(scanButton)
  end

  def pushExampleScannerViewController
    scannerController = ScannerViewController.alloc.init
    self.navigationController.pushViewController(scannerController, animated:true)
  end

end