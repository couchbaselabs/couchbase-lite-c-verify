ARG OS_NAME
ARG OS_VERSION
ARG OS_ARCH

FROM --platform=linux/$OS_ARCH $OS_NAME:$OS_VERSION

ARG OS_ARCH # Redeclare to use after FROM

COPY . /opt/app
WORKDIR /opt/app

RUN ./scripts/prepare_docker.sh $OS_ARCH

CMD ./scripts/verify_linux_zip.sh $CBL_ARCH $CBL_VERSION $CBL_BUILD $CBL_EDITION
