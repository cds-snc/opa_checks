# OPA Policy

## Tools installed

- [conftest](https://github.com/open-policy-agent/conftest)
- [fregot](https://github.com/fugue/fregot)
- [terraform](https://www.terraform.io/)
- [Open Policy Agent (opa) cli](https://www.openpolicyagent.org/docs/latest/#running-opa)

## Things we are testing for

| Name | Description | Severity |
| ---- | ----------- | -------- | 
| Invalid effect | IAM Policy `Effect` is only `Approve` or `Deny`| DENY |
| Lambda VPC ENI permission | A lambda attached to a VPC is missing the permissions to mange an ENI | DENY |
| Postgres DB password | Postgres DB password is:<ul><li>greater than 8 characters</li><li>only has valid characters</li><li>is not on the reserved list</li></ul> | DENY |
| Postgres DB username | Postgres DB username is:<ul><li>greater than 16 characters</li><li>only has valid characters</li><li>is not on the reserved list</li></ul> | DENY |
| Postgres DB name | Postgres DB name is:<ul><li>is not on the reserved list</li></ul> | DENY |
| Security group invalid ports | Deny if protocol is set to `-1` but the port range is not set to `0` | DENY |
| Tagging | All resources that allow tags have a `CostCentre` and `Terraform` tag | WARN |
| Unscoped IAM Service Roles | All IAM policies that have a service user as the `Principal` should have a condition limiting access to the account. (`sts:AssumeRole` actions are excepted) | WARN |
| Unsupported Lambda runtime | Checks if the lambda runtime is unsupported | DENY |

## How to run tests

Run the following command to run opa tests:

```bash
  make test
```

Run the following command to generate tf.plan to run against the test environment:

```bash
  make generate-plan
```

Run the following command to run conftest against an example tf.plan:

```bash
  make test-plan
```
