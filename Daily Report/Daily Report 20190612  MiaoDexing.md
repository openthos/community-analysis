# 如何在Ubuntu 16.04上建立一个Jekyll开发网站
https://cloud.tencent.com/developer/article/1356420

# Website
https://gitlab.com/fdroid/fdroid-website
## The F-Droid Website
This is the repository for the website at https://f-droid.org.  It
is based on Jekyll and you can find the development version
here.
## Building
You need to have Jekyll 3.2+ installed what is easily done with Gem which depends on Ruby 2.0+.
Because of the F-Droid plugin you need to have zlib installed.
```
sudo apt-get install ruby-full build-essential zlib1g-dev
gem install bundler:1.16.6
bundle install 
```
To build the website, run:
```
bundle exec jekyll build
```
If you want to build the website and
serve it with a local server at localhost:4000,
use:
```
bundle exec jekyll serve
```
