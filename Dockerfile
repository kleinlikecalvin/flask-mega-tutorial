FROM python:3.12-slim-bookworm
WORKDIR /usr/src/app
COPY ./requirements.txt /usr/src/app/
RUN ["pip", "install", "-r", "requirements.txt"]
CMD ["flask", "--app", "src/hello.py", "--debug", "run"]