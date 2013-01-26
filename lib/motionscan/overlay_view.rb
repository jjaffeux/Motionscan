module Motionscan

  class OverlayView < UIView

    def update(parent, result)
      unless result.nil?
      @parent = parent
        Dispatch::Queue.main.async do
          @actionSheet = UIActionSheet.alloc.initWithTitle("resultStr", delegate: self, cancelButtonTitle: "OK", destructiveButtonTitle: nil, otherButtonTitles: nil)
          @actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent
          @actionSheet.showInView(parent.view)
        end
      end
    end

    def actionSheet(actionSheet, didDismissWithButtonIndex:buttonIndex)
      p "clickedButtonAtIndex #{buttonIndex}"
      if buttonIndex == 0 
        @parent.session.resume
        @parent.result = nil
      end
    end

  end

end