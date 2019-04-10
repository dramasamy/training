# Start from Ubuntu 
FROM centos

# Update the pkgs 
RUN yum -y update

# Install Python and PIP
RUN yum install -y epel-release net-tools
RUN yum install -y python python-pip

# Install Flask web framework
RUN pip install flask

# Copy the python app to docker container 
COPY app.py /opt/app.py
RUN chmod +x /opt/app.py

# Add entry point
ENTRYPOINT FLASK_APP=python /opt/app.py
