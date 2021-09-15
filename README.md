# OPA Policy

## Tools installed

- [conftest](https://github.com/open-policy-agent/conftest)
- [fregot](https://github.com/fugue/fregot)
- [terraform](https://www.terraform.io/)
- [Open Policy Agent (opa) cli](https://www.openpolicyagent.org/docs/latest/#running-opa)

## How to run tests

Run the following command to run opa tests:

```bash
  make test
```

Run the following command to run conftest against an example tf.plan:

```bash
  conftest test ./test_inputs/test.json -p ./aws_terraform
```
