# DockerName: Locust runner
# Usecase: With locust runtime dependentance tools and testsuites
# Update: 2021-03-30
# Dependents:  python3
# Arch: x86-64
# Version: v0.5.0
# Editor：thomas
# Build In China

FROM  mltooling/ml-workspace:0.12.1
ENV PYTHON_HOME  /usr/bin/python3

WORKDIR /home/


RUN sudo cp -a /etc/apt/sources.list /etc/apt/sources.list.bak  \
    && sudo apt update    \ 
    && sudo apt install -y rustc zip unzip  \
    && wget https://dl.google.com/go/go1.16.3.linux-amd64.tar.gz   \  
    && rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz   \
    && export PATH=$PATH:/usr/local/go/bin   \
    && git clone -b master https://github.com/banrieen/MachineWolf.git   \
    && cd /home/MachineWolf/  \
    && git pull origin master  \
    && pip install --upgrade pip \
    && pip install python-dev-tools  \
    && pip install --ignore-installed -r /home/MachineWolf/requirements.ini \ 
    && bzt /home/MachineWolf/example/jmeter/trace_user_footprint.jmx  \
    && sudo curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  -s -- -y  \
    && sudo curl -fsSL https://deno.land/x/install/install.sh | sh   \
    && export DENO_INSTALL="/root/.deno"  \
    && echo "export PATH=$PATH:/root/.cargo/bin:$DENO_INSTALL/bin" >> /etc/profile  \
    && sudo /bin/bash -c "source /etc/profile" \
    && find . -regex "./[0-9]+" | xargs rm -rf \
    && rm -rf /tmp/*    \
    && ls -la /home/MachineWolf/ |egrep "^\d[0-9]*" | xargs rm -rf  \
    && rm -rf go1.16.3.linux-amd64.tar.gz

# port
# EXPOSE 1099 8080 8088 8089
# Run example
# docker run -d  -p 8088:8080   --name "machinewolf"  -v "${PWD}:/workspace"  --env NOTEBOOK_ARGS="--NotebookApp.notebook_dir=/home"   --shm-size 2048m     --restart always     banrieen/machinewolf:latest
