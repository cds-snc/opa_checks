package main

import data.tags as tags

deny[msg] {
  resources := tags.tags_contain_minimum_set[_]
  resources != []
  msg := sprintf("Missing CostCentre Tag: %v", [resources])
}