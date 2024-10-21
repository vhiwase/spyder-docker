# syntax=docker/dockerfile:experimental
FROM quay.io/unstructured-io/base-images:rocky9.2-gpu-latest as base

# NOTE(crag): NB_USER ARG for mybinder.org compat:
#             https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html
ARG NB_USER=notebook-user
ARG NB_UID=1000

# Set up environment
ENV HOME /home/${NB_USER}
ENV PYTHONPATH="${PYTHONPATH}:${HOME}"
ENV PATH="/home/usr/.local/bin:${PATH}"
ENV NB_USER=${NB_USER}
RUN groupadd --gid ${NB_UID} ${NB_USER}
RUN useradd --uid ${NB_UID} --gid ${NB_UID} ${NB_USER}
WORKDIR ${HOME}

FROM base as deps

COPY get-pip.py get-pip.py
COPY requirements requirements

# Install openssh-server using DNF (Fedora's package manager)
RUN python3.10 get-pip.py && \
  dnf -y groupinstall "Development Tools" && \
  find requirements/ -type f -name "*.txt" -exec python3 -m pip install --no-cache -r '{}' ';' && \
  dnf install -y openssh-server && \
  dnf -y groupremove "Development Tools" && \
  dnf clean all

RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN adduser -h ${HOME} -s /bin/sh -D ${NB_USER}
RUN echo -n '${NB_USER}:1234' | chpasswd

COPY ./entrypoint.sh /

LABEL maintainer="Vaibhav Hiwase"
EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]