#!/usr/bin/env python3
"""NetState Data lab web server: one page with a login form, over plain HTTP.

The form posts the username and password in clear text, so they can be read
straight off the wire in a capture. That is the point of the lesson.
"""
import os
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import parse_qs

USER = os.environ.get("LAB_USER", "netstate")
PASS = os.environ.get("LAB_PASS", "LabOnly-2026")

PAGE = """<!doctype html><html><head><meta charset="utf-8"><title>NetState Data</title></head>
<body style="font-family:sans-serif;max-width:32rem;margin:3rem auto">
<h1>NetState Data</h1><p>Staff sign-in (lab only)</p>{msg}
<form method="post" action="/login">
<p><label>Username <input name="username"></label></p>
<p><label>Password <input name="password" type="password"></label></p>
<p><button>Sign in</button></p></form></body></html>"""


class Handler(BaseHTTPRequestHandler):
    def _send(self, code, body):
        data = body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        self._send(200, PAGE.format(msg=""))

    def do_POST(self):
        length = int(self.headers.get("Content-Length", 0))
        form = parse_qs(self.rfile.read(length).decode("utf-8", "replace"))
        ok = form.get("username", [""])[0] == USER and form.get("password", [""])[0] == PASS
        msg = "<p><b>Signed in.</b></p>" if ok else "<p><b>Wrong username or password.</b></p>"
        self._send(200 if ok else 401, PAGE.format(msg=msg))

    def log_message(self, fmt, *args):
        print("[web] %s %s" % (self.address_string(), fmt % args), flush=True)


if __name__ == "__main__":
    print("[web] listening on :80 (plain HTTP)", flush=True)
    HTTPServer(("0.0.0.0", 80), Handler).serve_forever()
