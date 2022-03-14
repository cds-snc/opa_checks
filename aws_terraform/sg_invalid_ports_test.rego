package tests

import data.main as main

test_bad_ports_on_protocol {
	r := main.deny_sg_has_invalid_ports with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_security_group",
		"change": {"after": {
			"egress": [{
				"from_port": 443,
				"protocol": "-1",
				"to_port": 443,
			}],
			"ingress": [{
				"from_port": 443,
				"protocol": "-1",
				"to_port": 443,
			}],
		}},
	}]}

	count(r) == 1
	r[_] == "Security group has invalid ports for protocol: [\"foo\"]"
}

test_good_ports_on_protocol {
	r := main.deny_sg_has_invalid_ports with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_security_group",
		"change": {"after": {
			"egress": [{
				"from_port": 0,
				"protocol": "-1",
				"to_port": 0,
			}],
			"ingress": [{
				"from_port": 0,
				"protocol": "-1",
				"to_port": 0,
			}],
		}},
	}]}

	count(r) == 0
}

test_tcp_on_protocol {
	r := main.deny_sg_has_invalid_ports with input as {"resource_changes": [{
		"address": "foo",
		"type": "aws_security_group",
		"change": {"after": {
			"egress": [{
				"from_port": 443,
				"protocol": "tcp",
				"to_port": 443,
			}],
			"ingress": [{
				"from_port": 433,
				"protocol": "tcp",
				"to_port": 443,
			}],
		}},
	}]}

	count(r) == 0
}
