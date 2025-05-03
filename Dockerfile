FROM python:3.6

# Creating Application Source Code Directory
RUN mkdir -p /app

# Setting Home Directory for containers
WORKDIR /app

# Copy src python files
COPY classify.py train.py data_preload.py utils.py requirements.txt ./

# Upgrade pip to a compatible version
RUN python -m pip install --upgrade "pip<21.0"

# Installing python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# create directories for models and data
RUN mkdir -p /app/data
RUN mkdir -p /app/models

# Preload the data
RUN python data_preload.py

# Pretrain the models
RUN DATASET=mnist TYPE=ff python train.py
RUN DATASET=mnist TYPE=cnn python train.py
RUN DATASET=kmnist TYPE=ff python train.py
RUN DATASET=kmnist TYPE=cnn python train.py

# Running Python Application
CMD ["python", "classify.py"]
