[boss - yet another git deployment tool](http://irfandurmus.com/projects/boss/) 
===

Usage
---

Usage: boss [command] [arguments]
  
    Command   Arguments                 Description
  
    help                                Show short help
    test      server  project           Start tests on given server
    deploy    server  project  tag      Deploy given tag to given server
                                        Server should be local, stage or live
    rollback  server  project           If you dont give a tag boss will
                                        rollback previous version
    project   add                       To add new project
              list                      List all the project
              remove  project           Remove given project

Details
---
Please [check this page](http://irfandurmus.com/projects/boss/) for details.


