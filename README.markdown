[![CircleCI](https://circleci.com/gh/ministryofjustice/fb-pdf-generator/tree/master.svg?style=svg)](https://circleci.com/gh/ministryofjustice/fb-pdf-generator/tree/master)

# Form Builder PDF generator

## To run via Docker

You will need a running Docker daemon and docker-compose

```bash
make serve
```

Visit (http://localhost:3000)[http://localhost:3000]

## Running the tests

```bash
make spec
```

## Deployment

Continuous Integration (CI) is enabled on this project via CircleCI.

On merge to master tests are executed and if green deployed to the staging environment. This build can then be promoted to production
