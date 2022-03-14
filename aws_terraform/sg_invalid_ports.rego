package main

sg_has_invalid_ports[r] = resources {
	changes := input.resource_changes[r]
	resources := [resource |
		changes.type == "aws_security_group"
		resource := changes.address
		any([
			all([
				changes.change.after.egress[_].protocol == "-1",
				any([
					changes.change.after.egress[_].from_port != 0,
					changes.change.after.egress[_].to_port != 0,
				]),
			]),
			all([
				changes.change.after.ingress[_].protocol == "-1",
				any([
					changes.change.after.ingress[_].from_port != 0,
					changes.change.after.ingress[_].to_port != 0,
				]),
			]),
		])
	]
}

deny_sg_has_invalid_ports[msg] {
	address := sg_has_invalid_ports[_]
	address != []
	msg := sprintf("Security group has invalid ports for protocol: %v", [address])
}
