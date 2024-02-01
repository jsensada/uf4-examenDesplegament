from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello_instance():
    app.logger.info('Processing request for instance %s', app.instance_name)
    return "[OK] - " + app.instance_name + "]"

app.instance_name = os.getenv('INSTANCE') if os.getenv('INSTANCE') else "No instance provided"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')