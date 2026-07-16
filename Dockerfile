##
# Dockerfile that functions as the base in which we can build our .deb
# packages, and as such contains the necessary tooling to do this.

FROM ubuntu:latest

# Fixing debconf warning about TERM
ENV DEBIAN_FRONTEND teletype

# We need to ensure that the container user has the same UID and GID as the host buildkite agent to use the `propagate-uid-gid` feature of the docker plugin.
# The default UID, GID matches the default UID, GID of the buildkite agent on the host, if needed can be overridden
ARG USER_ID=929
ARG GROUP_ID=929
ARG USERNAME=builder
ARG HOME=/home/${USERNAME}
ARG COMMENT=builder

RUN apt update \
        && apt upgrade -y \
        && apt install -y binutils \
                          debhelper \
                          gettext \
                          openssl \
        && apt clean

RUN groupadd --gid $GROUP_ID $USERNAME
RUN useradd --comment "$COMMENT" --home-dir $HOME --create-home --system --uid $USER_ID --gid $GROUP_ID $USERNAME
USER $USERNAME
