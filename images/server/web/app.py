#!/usr/bin/env python3
"""NetState Data lab web server.

Phase 1: serves the login form over plain HTTP on :80, so the password can be
read straight off the wire. That is the lesson.

Phase 3: when a TLS certificate appears at /lab/tls/cert.pem (+ key.pem), the
server also serves the form over HTTPS on :443, and plain :80 starts
redirecting there. The learner creates that certificate by hand, so "move the
web server to HTTPS" is something they do, not something baked in.
"""
import os
import ssl
import threading
import time
from http.server import BaseHTTPRequestHandler, HTTPServer

from urllib.parse import parse_qs

CERT = "/lab/tls/cert.pem"
KEY = "/lab/tls/key.pem"
# The web login. Phase 1/2: the shared lab account. Phase 3: a web-only
# credential, once the learner writes one to /lab/web/users (user:pass).
WEB_USERS = "/lab/web/users"


def web_login():
    try:
        with open(WEB_USERS) as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and ":" in line:
                    u, p = line.split(":", 1)
                    return u.strip(), p.strip()
    except OSError:
        pass
    return (os.environ.get("LAB_USER", "netstate"),
            os.environ.get("LAB_PASS", "LabOnly-2026"))

# Set true once HTTPS is serving; plain HTTP then redirects instead of taking logins.
HTTPS_UP = False

PAGE = """<!doctype html><html><head><meta charset="utf-8"><title>NetState Data</title></head>
<body style="font-family:sans-serif;max-width:32rem;margin:3rem auto">
<h1>NetState Data</h1><p>Staff sign-in (lab only){scheme}</p>{msg}
<form method="post" action="/login">
<p><label>Username <input name="username"></label></p>
<p><label>Password <input name="password" type="password"></label></p>
<p><button>Sign in</button></p></form></body></html>"""


class Handler(BaseHTTPRequestHandler):
    def _send(self, code, body, headers=None):
        data = body.encode("utf-8")
        self.send_response(code)
        for k, v in (headers or {}).items():
            self.send_header(k, v)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    @property
    def _secure(self):
        return isinstance(self.connection, ssl.SSLSocket)

    def _redirect_to_https(self):
        host = (self.headers.get("Host") or "").split(":")[0]
        self._send(301, "<p>Moved to HTTPS.</p>", {"Location": "https://%s%s" % (host, self.path)})

    def do_GET(self):
        if HTTPS_UP and not self._secure:
            return self._redirect_to_https()
        scheme = " over HTTPS" if self._secure else ""
        self._send(200, PAGE.format(msg="", scheme=scheme))

    def do_POST(self):
        if HTTPS_UP and not self._secure:
            return self._redirect_to_https()
        length = int(self.headers.get("Content-Length", 0))
        form = parse_qs(self.rfile.read(length).decode("utf-8", "replace"))
        user, passwd = web_login()
        ok = form.get("username", [""])[0] == user and form.get("password", [""])[0] == passwd
        msg = "<p><b>Signed in.</b></p>" if ok else "<p><b>Wrong username or password.</b></p>"
        scheme = " over HTTPS" if self._secure else ""
        self._send(200 if ok else 401, PAGE.format(msg=msg, scheme=scheme))

    def log_message(self, fmt, *args):
        where = "https" if self._secure else "http"
        print("[web/%s] %s %s" % (where, self.address_string(), fmt % args), flush=True)


def serve_http():
    print("[web] listening on :80 (plain HTTP)", flush=True)
    HTTPServer(("0.0.0.0", 80), Handler).serve_forever()


def serve_https():
    global HTTPS_UP
    ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ctx.load_cert_chain(CERT, KEY)
    httpd = HTTPServer(("0.0.0.0", 443), Handler)
    httpd.socket = ctx.wrap_socket(httpd.socket, server_side=True)
    HTTPS_UP = True
    print("[web] listening on :443 (HTTPS); :80 now redirects", flush=True)
    httpd.serve_forever()


def watch_for_cert():
    # When the learner creates the certificate, bring HTTPS up without a restart.
    while not HTTPS_UP:
        if os.path.exists(CERT) and os.path.exists(KEY):
            try:
                serve_https()
            except Exception as e:  # bad/half-written cert: wait and retry
                print("[web] HTTPS not started yet: %s" % e, flush=True)
                time.sleep(2)
        time.sleep(1)


if __name__ == "__main__":
    threading.Thread(target=watch_for_cert, daemon=True).start()
    serve_http()
