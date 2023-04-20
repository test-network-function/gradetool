# gradetool

This is a simple application to read in a claim.json generated by running the [cnf-certification-test](https://github.com/test-network-function/cnf-certification-test) suite and give a score based on a pre-determined list of pass/fail/skipped tests.

## Development

In Visual Studio Code, you can edit your settings.json if you want to run this in debug mode by using something similar to the following:

```
{
    "launch": {

        "configurations": [
            {
                "name": "Launch Package",
                "type": "go",
                "request": "launch",
                "mode": "debug",
                "program": "/Users/bpalm/Repositories/go/src/github.com/test-network-function/gradetool/main.go",
                "args": ["-r /Users/bpalm/Repositories/go/src/github.com/test-network-function/gradetool/testdata/example-claim.json",  "-p /Users/bpalm/Repositories/go/src/github.com/test-network-function/gradetool/schemas/policy-good.json",  "-o /Users/bpalm/Repositories/go/src/github.com/test-network-function/gradetool/results/test.txt"],
            }
        ],
        "compounds": []
    }
}
```

To run the tool, you can run it straight from the source using:

- `make build`
- `./gradetool -p schemas/generated_policy.json -o results/test.txt -r testdata/example-claim.json`

## Using Docker/Podman

You can run the tool directly using `docker` or `podman` using the following example:

`docker run -v generated_policy.json:/policy.json -v testdata/example-claim.json:/claim.json quay.io/testnetworkfunction/gradetool:latest -p /policy.json -o results/test.txt -r /claim.json`

Example used during development:

`docker run -v /Users/bpalm/Repositories/go/src/github.com/test-network-function/gradetool/schemas/generated_policy.json:/policy.json -v /Users/bpalm/Repositories/go/src/github.com/test-network-function/gradetool/testdata/example-claim.json:/claim.json quay.io/testnetworkfunction/gradetool:latest -p /policy.json -o results/test.txt -r /claim.json`

The trick to this command is that you have to mount the incoming policy file and claim file as volumes prior to running.  This does make it easier to run so you do not have to build the binary first, etc.