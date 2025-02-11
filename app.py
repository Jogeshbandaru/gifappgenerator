from flask import Flask, jsonify
import random

app = Flask(__name__)

cat_gifs = [
    "https://cataas.com/cat/gif",
    "https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif",
    "https://media.giphy.com/media/mlvseq9yvZhba/giphy.gif"
]

@app.route('/')
def home():
    return "Welcome to the Cat GIF Generator!"

@app.route('/cat')
def get_cat_gif():
    return jsonify({"cat_gif": random.choice(cat_gifs)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
