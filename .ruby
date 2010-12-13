--- 
name: brite
title: Brite
contact: http://googlegroups.com/group/proutils
subtitle: Light Up Your Site
resources: 
  repository: git://github.com/proutils/brite.git
  homepage: http://proutils.github.com/brite
requires: 
- group: []

  name: neapolitan
  version: 0.3.0+
pom_verison: 1.0.0
manifest: 
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
- lib/brite/version.yml
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
- HISTORY.rdoc
- PROFILE
- LICENSE
- README.rdoc
- VERSION
suite: proutils
version: 0.6.0
licenses: 
- Apache v2.0
copyright: Copyright (c) 2006,2009 Thomas Sawyer
description: Brite is a remarkably easy to use, light-weight website generator. It supports a variety of backend rendering engines including rhtml via eruby, textile via redcloth, markdown via rdiscount, with others on the way.
summary: Super Simple Static Site Generation
authors: 
- Thomas Sawyer
