<!>Not production ready<!>

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jjaffeux/Motionscan)


# Description

Motionscan is a RubyMotion wrapper for the Moodstocks SDK. Moodstocks provide an incredibly fast and easy tool to add image recognition to your app.

Watch the video to see what you will be able to build in few minutes : http://cl.ly/0Q3K163y3b12


# Usage
- Create an account on moodstocks.com
- Use Moodstocks image uploader to add images to your account
- Complete your application Rakefile with RakefileExample (most notably pod and credentials)
- Look at /app to use it in your application
- Not yet pushed to rubygems, you have to build the gem and link to it from your Gemfile

If you want build this application you need to upload images with json attached to images, for example : 
http://cl.ly/image/3l331E0K0L2P

# Documentation
## Motionscan::Sync
    
Moodstocks is fast because the image processor is fast but also because it allows you to cache image signature, the Sync class allows you to decide when and how you want to sync the device cache.

-init
```ruby
sync = Motionscan::Sync.init
```

-startWithStatus(syncStarted, success:syncCompleted, error:syncFailed, progress:syncProgressed)
```ruby
sync.startWithStatus(
  lambda {
    # sync started
  },
  success:lambda {|result|
    # sync finished
    # Motionscan::Result instance
  },
  error:lambda {|error|
    # an error occured while syncing
    # NSError
  },
  progress:lambda {|progress, total|
    # progress : current number of cached items
    # total : number of items to cache
  }
)
```

## Motionscan::Scanner


-initWithFrame(frame)
```ruby
scanner = Motionscan::Scanner.initWithFrame([[0,0],[320,200]])
```

-frame=(frame)
```ruby
scanner.frame = [[0,0],[320,200]]
```

-displayScannerInView(view)
```ruby
scanner.displayScannerInView(self.view)
```

-startWithStatus(scanStarted, success:scanCompleted, error:scanError, notFound:scanNotFound)
```ruby
scanner.startWithStatus(
  lambda {
  	# scan started
    # will fire once at the beginning
    # from this point everything captured 
    # by the video will be scanned
  },
  success:lambda {|result|
  	# scan found and image in the cache
    # Motionscan::Result instance
  },
  error:lambda {|error|
  	# scan error
    # NSError 
  },
  notFound:lambda {
  	# scan didn't find the image in the cache
    # you shouldn't do anything expensive here
    # as it will fire very frequently
  }
)
```


-pause

If you wish to pause the scanner, and prevent current result to change you can use this method. Use scanner.resume to resume scanning process.
```ruby
scanner.pause
```

-stop

Call this method to terminate the scanner, usually in viewWillDisappear(animated). /!\ You have to call it at some point or pushing a new UIViewController and going back to this one, will crash the app.
```ruby
scanner.stop
```

-resume

```ruby
scanner.resume
```

-snapWithStatus(searchStarted, success:searchCompleted, error:searchError, notFound:searchNotFound)

If an image is not in the cache, you can trigger an API call to search it on your account.

```ruby
scanner.snapWithStatus(
  lambda {
  	#search in remote started
  },
  success:lambda {|result|
  	#search found and image in remote
  },
  error:lambda {|error|
  	#search error
  },
  notFound:lambda {
  	#search didn't find the image in remote
  }
)
```

## Motionscan::Result

Result is a simple wrapper arround MSResult, every methods that should return a result will give an instance of Motionscan::Result.

-imageId

Returns the imageId of the scanned image.

```ruby
result.imageId
```

-msSDKResult

Let you access the raw MSResult

```ruby
result.msSDKResult
```

-data

```ruby
result.data
```

Returns the string or the hash (json is converted to a hash) saved with the image. For example if the following json is attached to your image :
```ruby
{"type":"businessCat", "name":"Carl"}
```

You will get the following ruby hash :
```ruby
result.data
# {type:"businessCat", name:"Carl"}
```
