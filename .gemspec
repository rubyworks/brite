--- !ruby/object:Gem::Specification 
name: brite
version: !ruby/object:Gem::Version 
  hash: 7
  prerelease: false
  segments: 
  - 0
  - 6
  - 0
  version: 0.6.0
platform: ruby
authors: 
- Thomas Sawyer
autorequire: 
bindir: bin
cert_chain: []

date: 2011-05-13 00:00:00 -04:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: neapolitan
  prerelease: false
  requirement: &id001 !ruby/object:Gem::Requirement 
    none: false
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        hash: 19
        segments: 
        - 0
        - 3
        - 0
        version: 0.3.0
  type: :runtime
  version_requirements: *id001
description: Brite is a remarkably easy to use, light-weight website generator. It supports a variety of backend rendering engines including rhtml via eruby, textile via redcloth, markdown via rdiscount, with others on the way.
email: transfire@gmail.com
executables: 
- brite-server
- brite
extensions: []

extra_rdoc_files: 
- README.rdoc
files: 
- .ruby
- bin/brite
- bin/brite-server
- lib/brite/command.rb
- lib/brite/config.rb
- lib/brite/controller.rb
- lib/brite/layout.rb
- lib/brite/models/model.rb
- lib/brite/models/page.rb
- lib/brite/models/post.rb
- lib/brite/models/site.rb
- lib/brite/rackup.rb
- lib/brite/server.rb
- lib/brite/version.rb
- lib/brite.rb
- lib/plugins/sow/brite/awesome/Sowfile
- lib/plugins/sow/brite/awesome/about.page
- lib/plugins/sow/brite/awesome/assets/custom.less
- lib/plugins/sow/brite/awesome/assets/fade.png
- lib/plugins/sow/brite/awesome/assets/highlight.css
- lib/plugins/sow/brite/awesome/assets/highlight.js
- lib/plugins/sow/brite/awesome/assets/jquery.js
- lib/plugins/sow/brite/awesome/assets/jquery.tabs.js
- lib/plugins/sow/brite/awesome/assets/reset.css
- lib/plugins/sow/brite/awesome/assets/ruby.png
- lib/plugins/sow/brite/awesome/brite.yaml
- lib/plugins/sow/brite/awesome/history.page
- lib/plugins/sow/brite/awesome/index.page
- lib/plugins/sow/brite/awesome/legal.page
- lib/plugins/sow/brite/awesome/logs.page
- lib/plugins/sow/brite/awesome/page.layout
- lib/plugins/sow/brite/blog1/.rsync-filter
- lib/plugins/sow/brite/blog1/2011/01/sample.html
- lib/plugins/sow/brite/blog1/2011/01/sample.post
- lib/plugins/sow/brite/blog1/Sowfile
- lib/plugins/sow/brite/blog1/assets/images/bg.jpg
- lib/plugins/sow/brite/blog1/assets/images/icon.jpg
- lib/plugins/sow/brite/blog1/assets/styles/class.css
- lib/plugins/sow/brite/blog1/assets/styles/id.css
- lib/plugins/sow/brite/blog1/assets/styles/misc.css
- lib/plugins/sow/brite/blog1/assets/styles/print.css
- lib/plugins/sow/brite/blog1/assets/styles/reset.css
- lib/plugins/sow/brite/blog1/assets/styles/tag.css
- lib/plugins/sow/brite/blog1/brite.yml
- lib/plugins/sow/brite/blog1/index.page
- lib/plugins/sow/brite/blog1/page.layout
- lib/plugins/sow/brite/blog1/post.layout
- Apache2.txt
- README.rdoc
- History.rdoc
- NOTICE.rdoc
has_rdoc: true
homepage: http://rubyworks.github.com/brite
licenses: 
- Apache v2.0
post_install_message: 
rdoc_options: 
- --title
- Brite API
- --main
- README.rdoc
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      hash: 3
      segments: 
      - 0
      version: "0"
required_rubygems_version: !ruby/object:Gem::Requirement 
  none: false
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      hash: 3
      segments: 
      - 0
      version: "0"
requirements: []

rubyforge_project: brite
rubygems_version: 1.3.7
signing_key: 
specification_version: 3
summary: Super Simple Static Site Generation
test_files: []

