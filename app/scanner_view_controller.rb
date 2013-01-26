class ScannerViewController < Motionscan::ScannerViewController

  def viewDidLoad
    super
    self.flashEnabled = true
    p self.flashEnabled
  end

end