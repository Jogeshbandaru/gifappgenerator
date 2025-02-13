from flask import Flask, jsonify
import random

app = Flask(__name__)

cat_gifs = [
    "https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif",
    "https://media.giphy.com/media/mlvseq9yvZhba/giphy.gif",
    "https://media.giphy.com/media/3oriO0OEd9QIDdllqo/giphy.gif",
    "https://media.giphy.com/media/VbnUQpnihPSIgIXuZv/giphy.gif"
]

@app.route('/')
def get_cat_gif():
    return jsonify({"cat_gif": random.choice(cat_gifs)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
