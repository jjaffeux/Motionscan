module Motionscan

  class Sync

    attr_reader :scanner

    def self.init
      instance = allocate
      instance
    end

    def startWithStatus(syncStarted, success:syncCompleted, 
      error:syncFailed, progress:syncProgressed)
      @syncStarted = syncStarted
      @syncCompleted = syncCompleted
      @syncFailed = syncFailed
      @syncProgressed = syncProgressed

      @scanner = MSScanner.sharedInstance
      @scanner.syncWithDelegate(self) unless @scanner.isSyncing
    end

  private

    def scannerWillSync(scanner)
      @syncStarted.call
    end

    def didSyncWithProgress(progress, total:total)
      @syncProgressed.call(progress, total)
    end

    def scannerDidSync(scanner)
      @lastSync = NSDate.date.timeIntervalSince1970
      @syncCompleted.call(scanner.count(nil))
    end
    
    def scanner(scanner, failedToSyncWithError:error)
      errorCode = error.code
      if errorCode >= 0 and errorCode != MS_BUSY
        errorString = NSString.stringWithCString(ms_errmsg(errorCode), encoding:NSUTF8StringEncoding)
        NSLog("[MOODSTOCKS SDK] FAILED TO SYNC WITH ERROR : #{errorString}.")
      end
      @syncFailed.call(error)
    end

  end

end