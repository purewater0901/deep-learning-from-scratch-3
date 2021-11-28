FROM nvidia/cuda:11.1-devel-ubuntu20.04
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# update packages and install commands
RUN apt update && DEBIAN_FRONTEND=noninteractive \
    apt install -y --no-install-recommends \
    wget sudo vim git curl python3 python3-pip python3-tk ansible gnupg lsb-release build-essential libssl-dev libffi-dev python3-dev
RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
RUN apt update && apt install -y --no-install-recommends nodejs
RUN apt upgrade -y
RUN apt clean && \
    rm -rf /var/lib/apt/lists/*

# install pytorch and argoverse
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir numpy matplotlib scipy tqdm sklearn pandas jupyter jupyterlab notebook jupyterlab_vim jupyter_contrib_nbextensions pyparsing==2.4.7 cupy-cuda111 Pillow
RUN pip3 install --no-cache-dir torch==1.8.0+cu111 torchvision==0.9.0+cu111 torchaudio==0.8.0 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install torch-scatter torch-sparse torch-cluster torch-spline-conv torch-geometric -f https://data.pyg.org/whl/torch-1.8.0+cu111.html
RUN git clone https://github.com/purewater0901/argoverse-api.git
RUN pip3 install -e /argoverse-api
RUN rm -rf ~/.cache/pip /src/

# vim binding for jupter lab
RUN jupyter serverextension enable --py jupyterlab

# vim binding for jupyter lab
RUN jupyter contrib nbextension install --user
RUN jupyter nbextensions_configurator enable --user
RUN git clone https://github.com/lambdalisue/jupyter-vim-binding /root/.local/share/jupyter/nbextensions/vim_binding
RUN jupyter nbextension enable vim_binding/vim_binding
WORKDIR /

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# oepn port
EXPOSE 8888

# create user
#ARG DOCKER_UID=1000
#ARG DOCKER_USER=docker
#ARG DOCKER_PASSWORD=docker
#RUN useradd -m --uid ${DOCKER_UID} --groups sudo ${DOCKER_USER} && echo ${DOCKER_USER}:${DOCKER_PASSWORD} | chpasswd

#USER ${DOCKER_USER}

# create data direcotry
WORKDIR /work/data
WORKDIR /work

CMD ["/bin/bash"]
