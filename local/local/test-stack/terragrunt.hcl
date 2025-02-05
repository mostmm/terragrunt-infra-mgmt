include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "stack" {
  path   = "${dirname(find_in_parent_folders())}/_common/test-stack.hcl"
  expose = true
}

terraform {
  source = "${include.root.locals.modules_uri}/${include.stack.locals.name}"
}

inputs = {
  echo = "from the '${include.stack.locals.name}' module at stack: '${include.root.locals.component_path}'"
}
