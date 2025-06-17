from flask import Flask, render_template, request, redirect, url_for
import os, numpy as np

app = Flask(__name__)
DATA_FILE = "data.txt"

def read_data():
    Vs, Is = [], []
    if os.path.exists(DATA_FILE):
        with open(DATA_FILE) as f:
            for line in f:
                try:
                    v, i = line.strip().split(',')
                    Vs.append(float(v)); Is.append(float(i))
                except ValueError:
                    continue
    return np.array(Vs), np.array(Is)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    V = request.form.get('voltage', type=float)
    I = request.form.get('current', type=float)
    with open(DATA_FILE, 'a') as f:
        f.write(f"{V},{I}\n")
    return redirect(url_for('results'))

@app.route('/results')
def results():
    Vs, Is = read_data()
    # pack for Chart.js
    points = [{"x": float(v), "y": float(i)} for v, i in zip(Vs, Is)]

    slope = intercept = err_slope = err_intercept = None

    if Vs.size >= 2:
        # best‐fit line
        m, b = np.polyfit(Vs, Is, 1)
        slope, intercept = float(m), float(b)
        # only compute covariance (errors) if you have >2 points
        if Vs.size > 2:
            _, cov = np.polyfit(Vs, Is, 1, cov=True)
            err_slope, err_intercept = map(float, np.sqrt(np.diag(cov)))

    return render_template(
        'results.html',
        points=points,
        slope=slope,
        intercept=intercept,
        err_slope=err_slope,
        err_intercept=err_intercept
    )

if __name__ == '__main__':
    open(DATA_FILE, 'a').close()
    app.run(host='0.0.0.0', port=5000, debug=True)
