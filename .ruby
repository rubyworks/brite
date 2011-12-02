---
source:
- var
authors:
- name: trans
  email: transfire@gmail.com
copyrights:
- holder: Rubyworks
  year: '2006'
replacements: []
alternatives: []
requirements:
- name: neapolitan
  version: 0.4.0+
- name: detroit
  groups:
  - build
  development: true
- name: reap
  groups:
  - build
  development: true
- name: lemon
  groups:
  - test
  development: true
- name: ae
  groups:
  - test
  development: true
dependencies: []
conflicts: []
repositories:
- uri: git://github.com/rubyworks/brite.git
  scm: git
  name: upstream
resources:
  home: http://rubyworks.github.com/brite
  code: http://github.com/rubyworks/brite
  bugs: http://github.com/rubyworks/brite/issues
  mail: http://groups.google.com/groups/rubyworks-mailinglist
extra: {}
load_path:
- lib
revision: 0
summary: Super Simple Static Site Generation
title: Brite
version: 0.7.0
name: brite
description: ! 'Brite is a remarkably easy to use, light-weight website generator.
  It supports

  a variety of backend rendering engines including erb, liquid, rdoc, markdown,

  textile and so on.'
organization: RubyWorks
date: '2011-12-02'
