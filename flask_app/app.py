from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/hello')
def hello_world():
    return jsonify({'message': 'My Name is Viet'})

if __name__ == '__main__':
    app.run(debug=True)
