package tags

minimum_tags = {
  "CostCentre"
}

tags_contain_proper_keys(tags) {
  keys := {key | tags[key]}
  leftover := minimum_tags - keys
  leftover == set()
}

tags_contain_minimum_set[i] = resources {
  tags := input.resource_changes[i].change.after.tags
  resources := [
    resource |
    resource := input.resource_changes[i].address;
    not tags_contain_proper_keys(tags)
  ]
}

