#! /bin/python
from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello():
    return "Hello World! - v1"


@app.route('/<name>')
def hello_name(name):
    return "Hello {}! - v1".format(name)


@app.route('/audio')
def audio():
    return "Audio - v1"


@app.route('/video')
def video():
    return "Video - v1"


if __name__ == '__main__':
    app.run(host='0.0.0.0')
