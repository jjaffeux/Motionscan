class DebugOverlayViewExample < Motionscan::OverlayView

    def session(session, didScanWithResult:result)
    end

    def sessionDidScanWithoutResult(session)
    end

    def session(session, failedToScan:error)
    end

    def scannerWillSearch(scanner)
    end

    def scanner(scanner, didSearchWithResult:result)
    end

end