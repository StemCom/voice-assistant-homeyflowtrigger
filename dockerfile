ARG TAG=latest
FROM docker.io/smartgic/ovos-skill-base:${TAG}

ARG OVOS_USER=ovos

USER root

RUN apk update && apk add --no-cache \
    nodejs \
    npm \    
    curl \
    bash

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PATH="/usr/local/bin:$PATH"

# kopieer de skill zelf
WORKDIR /home/ovos/ovos-skill-HomeyFlowTrigger
COPY . .

# installeer de python dependencies
RUN pip install --upgrade pip \
 && pip install -e . \
 && uv pip install -U ovos-workshop \
 && uv pip install docker

RUN chown ${OVOS_USER}:${OVOS_USER} -R /home/ovos/ovos-skill-HomeyFlowTrigger

USER ${OVOS_USER}

# Default CMD: init/install Node modules bij runtime
WORKDIR /home/ovos/ovos-skill-HomeyFlowTrigger/nodejs
CMD ["sh", "-c", "\
  cd /home/ovos/ovos-skill-HomeyFlowTrigger/nodejs && \  
  npm init -y || true && \
  npm install homey-api && \
  npm install && \
  cd /home/ovos/ovos-skill-HomeyFlowTrigger && \
  exec ovos-skill-launcher ovos-skill-homeyflowtrigger.mennebos \
"]

  # exec ovos-skill-launcher ovos-skill-homeyflowtrigger.mennebos \
#"]

# --- ENTRYPOINT: start OVOS skill ---
#ENTRYPOINT ["sh", "-c", "\
#  cd /home/ovos/ovos-skill-HomeyFlowTrigger && \
#  exec ovos-skill-launcher ovos-skill-homeyflowtrigger.mennebos \
#"]

# ENTRYPOINT start de skill
#ENTRYPOINT ["ovos-skill-launcher", "ovos-skill-homeyflowtrigger.mennebos"]