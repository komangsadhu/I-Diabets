# app.py
from flask import Flask, request, jsonify
import joblib

app = Flask(__name__)
model = joblib.load('decision_tree_model.pkl')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json
    try:
        features = [[
            float(data['age']),
            float(data['bmi']),
            float(data['glucose']),
            float(data['bp'])
        ]]
        prediction = model.predict(features)[0]
        result = "Berisiko Diabetes" if prediction == 1 else "Tidak Berisiko Diabetes"
        return jsonify({'result': result})
    except Exception as e:
        return jsonify({'error': str(e)})
if __name__ == '__main__':
    app.run(debug=True)
