module Motionscan

  module Flash

    def flash
      flashView = UIView.alloc.initWithFrame(self.scannerView.bounds)
      flashView.backgroundColor = UIColor.whiteColor
      self.scannerView.addSubview(flashView)

      UIView.animateWithDuration(0.4,
        animations:lambda { flashView.alpha = 0.0 },
        completion:lambda { |finished| flashView.removeFromSuperview }
      )
    end

  end

end