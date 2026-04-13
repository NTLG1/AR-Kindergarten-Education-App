import cv2
import numpy as np
from flask import Flask, request, jsonify
import json

app = Flask(__name__)

# Initialize the OpenCV QRCodeDetector
qr_detector = cv2.QRCodeDetector()

@app.route('/detect_qr', methods=['POST'])
def detect_qr():
    # Ensure that the request contains a file
    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['file']

    # Read the image data from the file
    image = np.frombuffer(file.read(), np.uint8)
    img = cv2.imdecode(image, cv2.IMREAD_COLOR)

    # Detect and decode the QR code
    data, vertices, _ = qr_detector.detectAndDecode(img)

    # If a QR code is found, return its vertices and embedded object info
    if data and vertices is not None:
        # Try to parse the data string as JSON
        try:
            parsed_data = json.loads(data)
            object_name = parsed_data.get("object", "Unknown")
        except json.JSONDecodeError:
            object_name = data  # If it's not in JSON format, return the raw data

        # The vertices are in an array of 4 corner points (x, y)
        points = [{"x": int(pt[0]), "y": int(pt[1])} for pt in vertices[0]]

        # Return JSON with the vertices and extracted object name
        return jsonify({
            "vertices": points,
            "objectName": object_name  # Return the extracted object name
        })
    else:
        return jsonify({"error": "No QR code detected"}), 400

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=3060)
