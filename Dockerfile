FROM python:3.7-slim-buster

RUN apt update
RUN apt -y install busybox fonts-ipaexfont-gothic
RUN busybox --install
RUN pip install jupyter pandas matplotlib more-itertools pulp ortools ortoolpy
ENV USER=scientist HOME=/home/scientist
ENV uid=1000 gid=1000 pswd=scientist
RUN groupadd -g $gid $USER
RUN useradd -g $USER -G sudo -m -s /bin/bash $USER
RUN echo "$USER:$pswd" | chpasswd
RUN mkdir -p /etc/sudoers.d $HOME/notebooks
RUN echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER
RUN chmod 0440 /etc/sudoers.d/$USER
USER $USER
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password = 'sha1:a457f3e31937:be3aa80a1d2e58d4b02a1adb8a99869683472e3b'" > $HOME/.jupyter/jupyter_notebook_config.py
ADD notebooks $HOME/notebooks
WORKDIR $HOME/notebooks
CMD ["jupyter-notebook", "--ip=0.0.0.0"]