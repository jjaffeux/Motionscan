module Motionscan

  class OverlayView < UIView

    attr_accessor :scanner

    def session(session, didScan:result)
    end

    def session(session, failedToScan:error)
    end

    def scannerWillSearch(scanner)
    end

    def scanner(scanner, didSearchWithResult:result)
    end

  end

end