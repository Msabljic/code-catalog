pamlist = [{
  group_name = "test-dummy"
  acls = [{
    associate_role_id = ""
  }]
  },
  {
    group_comment = "its a group"
    group_name    = "test-dummer"
    acls = [{
      group_path        = "/vms"
      group_propagate   = false
      associate_role_id = ""
    }]
}]
userlist = [{
  user_id                = "dummy"
  user_group_association = ["grp-test-dummy"]
  first_name             = "du"
  last_name              = "mmy"
  email                  = "dummy@corp.org"
}]
rolelist = [{
  role_name       = "new_role"
  role_privileges = ["viewer"]
}]