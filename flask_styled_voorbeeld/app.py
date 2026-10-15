"""
Eenvoudige Flask-demo met nette opmaak (Pico.css via CDN).

Starten (in deze map):
  python -m venv .venv
  .venv\\Scripts\\activate   # Windows
  pip install -r requirements.txt
  flask --app app run --debug

Open daarna http://127.0.0.1:5000 in je browser.
"""

from flask import Flask, flash, redirect, render_template, request, url_for

app = Flask(__name__)
app.secret_key = "alleen-voor-lokaal-testen-wijzig-in-productie"


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/formulier", methods=["GET", "POST"])
def formulier():
    if request.method == "POST":
        naam = (request.form.get("naam") or "").strip()
        if not naam:
            flash("Vul een naam in.", "invalid")
        else:
            flash(f"Bedankt, {naam}!", "valid")
            return redirect(url_for("formulier"))
    return render_template("formulier.html")
