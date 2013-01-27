# Description

Motionscan is a RubyMotion wrapper for the Moodstocks SDK. Moodstocks provide you an incredibly fast and easy tool to add image recognition to your app.

Watch the video to see what you will be able to build in few minutes : http://cl.ly/0Q3K163y3b12


# Usage
- Create an account on moodstocks.com
- Use Moodstocks image uploader to add images to your account
- Complete your application Rakefile with RakefileExample (most notably pod and credentials)
- Look at example to use it in your application
- Not yet pushed to rubygems

If you want build this application you need to upload images with json attached to images, for example : 
http://cl.ly/image/3l331E0K0L2P

# Documentation
## Motionscan::Sync
    
Moodstocks is fast because the image processor is fast but also because it allows you to cache image signature, the Sync class allows you to decide when and how you want to sync device cache.

-init
```ruby
sync = Motionscan::Sync.init
```

-startWithStatus(syncStarted, success:syncCompleted, error:syncFailed, progress:syncProgressed)
```ruby
sync.startWithStatus(
  lambda {
  },
  success:lambda {|result|
  },
  error:lambda {|error|
  },
  progress:lambda {|progress, total|
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
  	#scan started
  },
  success:lambda {|result|
  	#scan found and image in the cache
  },
  error:lambda {|error|
  	#scan error
  },
  notFound:lambda {
  	#scan didn't find the image in the cache
  }
)
```


-pause

If you wish to pause the scanner, and prevent current result to change you can use this method. Use scanner.resume to resume scanning process.
```ruby
scanner.pause
```

-stop

When scanner usage is done you should call this method, usually in viewWillDisappear(animated)
```ruby
scanner.stop
```

-resume

```ruby
scanner.resume
```

-snapWithStatus(searchStarted, success:searchCompleted,error:searchError,notFound:searchNotFound)

If an image is not in the cache, you can trigger an API call to search on your account.

```ruby
scanner.snapWithStatus(
  lambda {
  	#search in remote started
  },
  success:lambda {|result|
  	#scan found and image in remote
  },
  error:lambda {|error|
  	#scan error
  },
  notFound:lambda {
  	#scan didn't find the image in remote
  }
)
```

## Motionscan::result


-imageId

Returns the imageId of the scanned image.

```ruby
result.imageId
```

-data

```ruby
result.data
```

Returns the string or the hash (json is converted to a hash) saved with the image
