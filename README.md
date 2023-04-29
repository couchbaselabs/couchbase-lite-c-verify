This repo uses Github actions to verify amd64 linux, iOS, android binaries and provides Dockerfile and Docker Compose YAML file that can be used for verifying the arm64 and armhf binaries.

## How to verify

### Verify amd64 linux, iOS, android binaries.

1. Update version number in version.txt

2. Create a PR with the update.

3. Github actions will be run to verify the binaries.

### Verify arm64 and armhf binaries.

1. cd desktop

2. Create .env file with the following info as an example

```
ARCH=arm64
VERSION=3.1.0
EDITION=enterprise
```
* ARCH : arm64 | armhf | amd64
* EDITION : enterprise | community


3. Run docker compose up and check the result

```
docker compose up
```

4. Clean up containers and images before running with new env variables.

```
docker compose down --rmi all
```

Note: I couldn't find a way to tell 'docker compose up' to use a new environment values to run the CMD in the Dockerfile without cleaning up containers and images.
