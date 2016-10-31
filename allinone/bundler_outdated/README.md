# Bundler Outdated

Find Bundler Outdated gems, this script need Gemfile, Gemfile.lock.

## Requirement

* ruby
* bundler(`gem install bundler` and `cd HERE_DIR; bundle install`)

## Useage

```
cd ruby_project_dir
# gem_analysis.rb TARGET_DIR_PATH OUTPUT_FILE_PATH
./gem_analysis.rb . output.json
or
ruby gem_analysis.rb . output.json
```

### Options

```
bundler_outdated --version or -v
```

## Output Formart

Result format is json.  
Example:

```
[
    {
        "latest": "1.0.3", 
        "locked": "1.0.3", 
        "package": "active_link_to", 
        "package_url": "http://rubygems.org/gems/active_link_to", 
        "requirement": "~> 1.0.2", 
        "status": "latest"
    }, 
    {
        "latest": "3.3.5.1", 
        "locked": "3.2.0.2", 
        "package": "bootstrap-sass", 
        "package_url": "http://rubygems.org/gems/bootstrap-sass", 
        "requirement": "~> 3.2.0.0", 
        "status": "outdated"
    }, 
    {
        "latest": "2.8.10", 
        "locked": "2.1.0", 
        "package": "bugsnag", 
        "package_url": "http://rubygems.org/gems/bugsnag", 
        "requirement": "~> 2.1.0", 
        "status": "outdated"
    }, 
    {
        "latest": "0.7.4", 
        "locked": "0.7.4", 
        "package": "timecop", 
        "package_url": "http://rubygems.org/gems/timecop", 
        "requirement": "~> 0.7.1", 
        "status": "latest"
    }, 
    {
        "latest": "2.1.0", 
        "locked": "2.1.0", 
        "package": "turnout", 
        "package_url": "http://rubygems.org/gems/turnout", 
        "requirement": ">= 0", 
        "status": "latest"
    }, 
    {
        "latest": "1.21.0", 
        "locked": "1.18.0", 
        "package": "webmock", 
        "package_url": "http://rubygems.org/gems/webmock", 
        "requirement": "~> 1.18.0", 
        "status": "outdated"
    }
]
```
