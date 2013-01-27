class AppDelegate

  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    controller = RootViewController.alloc.init
    navigationController = UINavigationController.alloc.initWithRootViewController(controller)
    self.window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.window.rootViewController = navigationController
    self.window.makeKeyAndVisible

    true
  end
end