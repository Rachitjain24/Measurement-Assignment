
# Voltage–Current Measurement & Regression Web App

A lightweight Flask application that lets you:

- **Enter measurement pairs** (Voltage in volts, Current in amperes) via a web form  
- **Store** each pair in a server-side text file (`data.txt`)  
- **Display** all readings in a dynamic HTML table  
- **Plot** an interactive scatter plot with best-fit line in the browser (using Chart.js)  
- **Compute** a linear regression (assuming negligible error in Voltage vs. Current error) and show slope/intercept with standard errors

---

## 🗂 Project Structure

```

measurement\_app/
├── app.py                # Flask server & regression logic
├── requirements.txt      # Python dependencies (Flask, NumPy)
├── data.txt              # CSV storage of “voltage,current” lines
└── templates/
├── index.html        # Data entry form (Voltage & Current)
└── results.html      # Table, regression stats & Chart.js plot

````

---

## ⚙️ Prerequisites

- Python 3.8+  
- pip (or pipenv/poetry)  
- A modern browser for viewing the Chart.js plot

---

## 📥 Installation

1. **Clone the repo**  
   ```bash
   git clone https://github.com/YOUR_USERNAME/REPO_NAME.git
   cd REPO_NAME


2. **Create & activate a virtual environment**

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. **Install dependencies**

   ```bash
   pip install -r requirements.txt
   ```

4. **Prepare the data file**

   ```bash
   touch data.txt
   chmod 666 data.txt
   ```

---

## 🚀 Running the App

```bash
# with venv activated
python app.py
```

Open your browser and navigate to:

* **Data Entry** → [http://localhost:5000/](http://localhost:5000/)
* **Results**    → [http://localhost:5000/results](http://localhost:5000/results)

---

## 📝 How It Works

1. **Data Entry (index.html)**

   * User fills in **Voltage (V)** and **Current (A)**.
   * Submits via POST to `/submit`.

2. **Storing the Data (app.py)**

   * The `/submit` route reads `voltage` and `current` from the form.
   * Appends a line `voltage,current` to `data.txt`.
   * Redirects to `/results`.

3. **Reading & Displaying (app.py & results.html)**

   * The `/results` route calls `read_data()`, which:

     * Opens `data.txt`
     * Parses each line into NumPy arrays `Vs` and `Is`
   * Packs raw points into a JSON-serializable list for Chart.js.
   * Renders `results.html` with:

     * An HTML table of all (V,I) readings
     * Regression parameters and errors
     * A `<canvas>` for the chart

4. **Linear Regression & Error Estimation**

   * If **≥ 2** points exist:

     * Calls `np.polyfit(Vs, Is, 1)` to get **slope** (m) and **intercept** (b)

       * Here, *slope* = ΔI/ΔV = 1/R (where R is resistance)
     * If **> 2** points, also calls `polyfit(..., cov=True)` to get covariance → standard errors σₘ, σ\_b
     * This assumes **σᵥ ≪ σᵢ**, so only Current error is significant.

5. **Interactive Plot (Chart.js)**

   * `results.html` includes Chart.js via CDN.
   * JavaScript reads the passed `points` and computes line endpoints from `m` & `b`.
   * Renders a scatter dataset plus a line dataset, with labeled axes.

---

## 🛠 Customization & Extensions

* **Additional fields**: Add new inputs in `index.html` and parse them in `app.py`.
* **Styling**: Modify the embedded CSS in the templates or link your own stylesheet.
* **Data export**: Provide a CSV download link by sending `data.txt`.
* **Authentication**: Wrap routes with Flask-Login or OAuth for user-restricted access.

---

## 👤 Author

Your Name – <[your\_email@example.com](mailto:your_email@example.com)>

Feel free to adapt, extend, and integrate this example into larger projects!
