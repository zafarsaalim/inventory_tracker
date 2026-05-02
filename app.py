from flask import Flask, render_template, request, redirect
import sqlite3
from datetime import date

app = Flask(__name__)

DB = "data.db"

def get_db():
    return sqlite3.connect(DB)

def init_db():
    conn = get_db()
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE IF NOT EXISTS clients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT
    )
    """)

    cur.execute("""
    CREATE TABLE IF NOT EXISTS entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER,
        amount REAL,
        type TEXT,
        date TEXT
    )
    """)

    conn.commit()
    conn.close()

init_db()

@app.route("/")
def index():
    conn = get_db()
    cur = conn.cursor()

    cur.execute("SELECT * FROM clients")
    clients = cur.fetchall()

    data = []

    for c in clients:
        cid = c[0]
        name = c[1]

        cur.execute("SELECT SUM(amount) FROM entries WHERE client_id=? AND type='given'", (cid,))
        given = cur.fetchone()[0] or 0

        cur.execute("SELECT SUM(amount) FROM entries WHERE client_id=? AND type='received'", (cid,))
        received = cur.fetchone()[0] or 0

        balance = given - received

        data.append((cid, name, balance))

    conn.close()
    return render_template("index.html", clients=data)


@app.route("/add-client", methods=["GET", "POST"])
def add_client():
    if request.method == "POST":
        name = request.form["name"]
        phone = request.form["phone"]

        conn = get_db()
        conn.execute("INSERT INTO clients (name, phone) VALUES (?, ?)", (name, phone))
        conn.commit()
        conn.close()

        return redirect("/")

    return render_template("add_client.html")

@app.route("/add-entry/<int:client_id>", methods=["GET", "POST"])
def add_entry(client_id):
    if request.method == "POST":
        amount = float(request.form["amount"])
        etype = request.form["type"]
        today = str(date.today())

        conn = get_db()
        conn.execute(
            "INSERT INTO entries (client_id, amount, type, date) VALUES (?, ?, ?, ?)",
            (client_id, amount, etype, today)
        )
        conn.commit()
        conn.close()

        return redirect("/")

    return render_template("add_entry.html", client_id=client_id)

@app.route("/client/<int:client_id>")
def client_detail(client_id):
    conn = get_db()
    cur = conn.cursor()

    # client info
    cur.execute("SELECT * FROM clients WHERE id=?", (client_id,))
    client = cur.fetchone()

    # entries
    cur.execute("SELECT amount, type, date FROM entries WHERE client_id=? ORDER BY id DESC", (client_id,))
    entries = cur.fetchall()

    # totals
    cur.execute("SELECT SUM(amount) FROM entries WHERE client_id=? AND type='given'", (client_id,))
    given = cur.fetchone()[0] or 0

    cur.execute("SELECT SUM(amount) FROM entries WHERE client_id=? AND type='received'", (client_id,))
    received = cur.fetchone()[0] or 0

    balance = given - received

    conn.close()

    return render_template("client.html", client=client, entries=entries, balance=balance)



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

