class ScannerViewController < Motionscan::ScannerViewController

  def initWithNibName(nibNameOrNil, bundle:nibBundleOrNil)
    super
    self.flashEnabled = true
    self.overlay = DebugOverlayViewExample.alloc.init
    self.overlay.scanner = self
  end

end