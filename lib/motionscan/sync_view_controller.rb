module Motionscan

  class SyncViewController < UIViewController

    attr_accessor :lastSync
    attr_accessor :syncInterval
    attr_accessor :syncWhenEnteringForeground
    attr_accessor :scanner

    def initWithNibName(nibNameOrNil, bundle:nibBundleOrNil)
      super
      self.lastSync = 0
      self.syncWhenEnteringForeground = true
      self.syncInterval = 1 #1 day
      self.scanner = MSScanner.sharedInstance
      self.scanner.syncWithDelegate(self) unless self.scanner.isSyncing
      self
    end

    def loadView
      super
      if self.syncWhenEnteringForeground
        NSNotificationCenter.defaultCenter.addObserver(self,
          selector: :sync,
          name:UIApplicationWillEnterForegroundNotification,
          object:nil)
      end
      self.sync
    end

    def viewWillDisappear(animated)
      super
      if self.syncWhenEnteringForeground
        NSNotificationCenter.defaultCenter.removeObserver(self,
          name:UIApplicationWillEnterForegroundNotification,
          object:nil)
      end
    end

    def sync
      self.scanner.syncWithDelegate(self) unless self.scanner.isSyncing
    end

    def scannerWillSync(scanner)
      App.shared.setNetworkActivityIndicatorVisible(true)
    end

    def didSyncWithProgress(progress, total:total)
    end

    def scannerDidSync(scanner)
      App.shared.setNetworkActivityIndicatorVisible(false)
      self.lastSync = NSDate.date.timeIntervalSince1970
    end
    
    def scanner(scanner, failedToSyncWithError:error)
      App.shared.setNetworkActivityIndicatorVisible(false)
      errorCode = error.code
      if errorCode >= 0 and errorCode != MS_BUSY
        errorString = NSString.stringWithCString(ms_errmsg(errorCode), encoding:NSUTF8StringEncoding)
        NSLog("[MOODSTOCKS SDK] FAILED TO SYNC WITH ERROR : #{errorString}.")
      end
    end

  end

end