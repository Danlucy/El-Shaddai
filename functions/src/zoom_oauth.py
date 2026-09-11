"""Authenticated browser-to-Zoom token transport (Zoom does not enable CORS)."""

import base64
import json
import re
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode
from urllib.request import Request, urlopen

from firebase_functions import https_fn


CLIENT_REDIRECTS = {
    "OLnqfeWuS1yQDh2alJOTQ": {
        "https://daniel-ong.com/zoom-login-successful/",
        "https://daniel-ong.com/zoom-login-successful",
        "https://daniel-ong.com/",
        "https://daniel-ong.com",
    },
    "tFVInLKQUez_GgvV3PTg": {"http://127.0.0.1:7537/auth.html"},
    "jotNDwMdQ1uqVCjfqqmz7w": {
        "https://247.elshaddaiprayeraltar.asia/auth.html"
    },
}

CLIENT_SECRETS = {
    "OLnqfeWuS1yQDh2alJOTQ": "Bi3RBwvo2z0vIPZ9KU50D9u9vgcGxlyI",
}


def _invalid():
    raise https_fn.HttpsError(
        https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
        "Invalid Zoom token request.",
    )


@https_fn.on_call(region="asia-southeast1", max_instances=5)
def zoomOAuthToken(request: https_fn.CallableRequest) -> dict:
    if request.auth is None:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.UNAUTHENTICATED,
            "Sign in to El Shaddai before connecting Zoom.",
        )
    data = request.data
    if not isinstance(data, dict):
        _invalid()
    client = data.get("client_id")
    if not isinstance(client, str) or client not in CLIENT_REDIRECTS:
        _invalid()
    grant = data.get("grant_type")
    payload = {"client_id": client, "grant_type": grant}
    if grant == "authorization_code":
        redirect = data.get("redirect_uri")
        verifier = data.get("code_verifier")
        code = data.get("code")
        if (not isinstance(redirect, str) or redirect not in CLIENT_REDIRECTS[client]
                or not isinstance(verifier, str)
                or not re.fullmatch(r"[A-Za-z0-9._~-]{43,128}", verifier)
                or not isinstance(code, str) or not 1 <= len(code) <= 4096):
            _invalid()
        payload.update(redirect_uri=redirect, code_verifier=verifier, code=code)
    elif grant == "refresh_token":
        token = data.get("refresh_token")
        if not isinstance(token, str) or not 1 <= len(token) <= 8192:
            _invalid()
        payload["refresh_token"] = token
    else:
        _invalid()

    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    if client in CLIENT_SECRETS:
        secret = CLIENT_SECRETS[client]
        creds = base64.b64encode(f"{client}:{secret}".encode("utf-8")).decode("ascii")
        headers["Authorization"] = f"Basic {creds}"

    upstream = Request(
        "https://zoom.us/oauth/token",
        data=urlencode(payload).encode("utf-8"),
        headers=headers,
        method="POST",
    )
    try:
        with urlopen(upstream, timeout=20) as response:
            result = json.load(response)
    except HTTPError as error:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.FAILED_PRECONDITION,
            "Zoom rejected the login or refresh. Please reconnect Zoom.",
        ) from error
    except (URLError, TimeoutError, ValueError) as error:
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.UNAVAILABLE,
            "Zoom is unavailable. Please try again.",
        ) from error
    if (not isinstance(result, dict)
            or not isinstance(result.get("access_token"), str)
            or not isinstance(result.get("refresh_token"), str)
            or not isinstance(result.get("expires_in"), (int, float))):
        raise https_fn.HttpsError(
            https_fn.FunctionsErrorCode.INTERNAL, "Invalid Zoom token response."
        )
    # Never log or persist OAuth codes, verifiers or tokens in the function.
    return {key: result[key] for key in ("access_token", "refresh_token", "expires_in")}
