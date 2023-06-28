This repo uses Github actions to verify Android, iOS, Windows, and amd64 linux binaries and provides Dockerfile and Docker Compose YAML file that can be used for verifying the arm64 and armhf linux binaries.

### Verification Matrix

<table>
<tr>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th colspan="4">Linux amd64</th>
  <th colspan="4">Linux arm64</th>
  <th colspan="4">Linux armhf</th>
<tr>
<tr>
  <th></th>
  <th>Android</th>
  <th>iOS</th>
  <th>Windows</th>
  <th>ubuntu 22.04</th>
  <th>ubuntu 20.04</th>
  <th>debian 11</th>
  <th>debian 10</th>
  <th>ubuntu 22.04</th>
  <th>ubuntu 20.04</th>
  <th>debian 11</th>
  <th>debian 10</th>
  <th>ubuntu 22.04</th>
  <th>ubuntu 20.04</th>
  <th>debian 11</th>
  <th>debian 10</th>
<tr>
<tr>
  <th>Github Action</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
<tr>
<tr>
  <th>Local Machine</th>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th></th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
  <th>x</th>
<tr>
</table>

> **Note** Each platform binary has two editions : Enterprise and Community

> **Note** debian 9 is pending for verification

## How to verify

### Github Action (android, iOS, windows, and amd64 linux)

1. Update version number in version.txt

2. Create a PR with the update.

3. Github actions will be run to verify the binaries.

### Local with Mac M1 (arm64 and armhf linux)

1. cd desktop

2. Run docker compose up and check the result:

```
ARCH=arm64 EDITION=enterprise VERSION=3.0.12 docker compose up --build
```

3. Change the ARCH and EDITION and run step 2 again.

```
* ARCH : arm64 | armhf
* EDITION : enterprise | community

4. Clean up containers and images

```
docker compose down --rmi all
```
