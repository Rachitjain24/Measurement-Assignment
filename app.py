from flask import Flask, request, render_template, abort
import subprocess

app = Flask(__name__)

@app.route('/')
def index():
    # Render the HTML form
    return render_template('index.html')

@app.route('/submit', methods=['POST'])
def submit():
    # Collect form data
    name  = request.form.get('name', '')
    email = request.form.get('email', '')

    # Invoke the Perl processor, passing form data on stdin
    proc = subprocess.run(
        ['perl', 'scripts/process.pl'],
        input=f"name={name}&email={email}",
        capture_output=True,
        text=True,
    )

    # If the Perl script failed, return a 500 with stderr
    if proc.returncode != 0:
        return abort(500, f"Error running process.pl:\n{proc.stderr}")

    # Otherwise return its stdout (the generated HTML)
    return proc.stdout

@app.route('/view')
def view():
    # Invoke the Perl viewer to render the table
    proc = subprocess.run(
        ['perl', 'scripts/view.pl'],
        capture_output=True,
        text=True,
    )

    if proc.returncode != 0:
        return abort(500, f"Error running view.pl:\n{proc.stderr}")

    return proc.stdout

if __name__ == '__main__':
    # Run on all interfaces, port 5000, with debug enabled
    app.run(host='0.0.0.0', port=3500, debug=True)
