# OPA Policy

## Tools installed

- [conftest](https://github.com/open-policy-agent/conftest)
- [fregot](https://github.com/fugue/fregot)
- [terraform](https://www.terraform.io/)
- [Open Policy Agent (opa) cli](https://www.openpolicyagent.org/docs/latest/#running-opa)

## Things we are testing for

| Name | Description |
| ---- | ----------- |
| Invalid effect | IAM Policy `Effect` is only `Approve` or `Deny`|
| Postgres DB password | Postgres DB password is:<ul><li>greater than 8 characters</li><li>only has valid characters</li><li>is not on the reserved list</li></ul> |
| Postgres DB username | Postgres DB username is:<ul><li>greater than 16 characters</li><li>only has valid characters</li><li>is not on the reserved list</li></ul> |
| Postgres DB name | Postgres DB name is:<ul><li>is not on the reserved list</li></ul> |
| Tagging | All resources that allow tags have a `CostCentre` and `Terraform` tag |
| Unscoped IAM Service Roles | All IAM policies that have a service user as the `Principal` should have a condition limiting access to the account. (`sts:AssumeRole` actions are excepted) |

## How to run tests

Run the following command to run opa tests:

```bash
  make test
```

Run the following command to run conftest against an example tf.plan:

```bash
  conftest test ./test_inputs/test.json -p ./aws_terraform
```
