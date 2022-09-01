FROM python:3.8-bullseye
RUN pip install --no-cache-dir --upgrade pip
RUN pip install -U scikit-image
# install cv2
RUN pip install opencv-python
RUN apt-get update
RUN apt-get install ffmpeg libsm6 libxext6  -y
#install bm3d
RUN pip install bm3d
RUN apt-get install libopenblas-dev -y
# install omnipose
#RUN pip install omnipose
#RUN apt-get install git-all -y
#RUN pip install git+https://github.com/MouseLand/cellpose/releases/tag/v0.7.2#egg=cellpose
RUN pip3 install cellpose==0.7.1
RUN pip install -U scikit-learn
# install pandas
RUN pip3 install pandas
# install matplotlib
RUN pip install matplotlib
RUN apt-get install vim -y
COPY job_call_main_docker.sh /home/scripts/
COPY python_bm3d_script_bash.py /home/scripts/
COPY extract_features_regionprops.py /home/scripts/
COPY strack_script_v4.py /home/scripts/
COPY bact_omnitorch_0 /home/scripts/
ENTRYPOINT ["bash", "/home/scripts/job_call_main_docker.sh"]
