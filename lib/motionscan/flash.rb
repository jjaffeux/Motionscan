module Motionscan

  module Flash

    def flash
      flashView = UIView.alloc.initWithFrame(@view.bounds)
      flashView.backgroundColor = UIColor.whiteColor
      @view.addSubview(flashView)

      UIView.animateWithDuration(0.4,
        animations:lambda { flashView.alpha = 0.0 },
        completion:lambda { |finished| flashView.removeFromSuperview }
      )
    end

  end

end
