import inspect
import io
import json
from types import SimpleNamespace
import unittest
from unittest.mock import patch
from urllib.parse import parse_qs
from urllib.error import HTTPError

from firebase_functions import https_fn
from src.zoom_oauth import zoomOAuthToken


class ZoomOAuthTests(unittest.TestCase):
    def setUp(self):
        self.call = inspect.unwrap(zoomOAuthToken)
        self.data = {
            "client_id": "tFVInLKQUez_GgvV3PTg",
            "grant_type": "authorization_code",
            "redirect_uri": "http://127.0.0.1:7537/auth.html",
            "code": "test-code",
            "code_verifier": "a" * 43,
        }

    def request(self, auth=True):
        return SimpleNamespace(data=self.data, auth=object() if auth else None)

    def test_requires_firebase_login(self):
        with patch("src.zoom_oauth.urlopen") as upstream:
            with self.assertRaises(https_fn.HttpsError):
                self.call(self.request(False))
            upstream.assert_not_called()

    def test_rejects_other_clients_redirects_grants_and_invalid_verifiers(self):
        for key, value in [("client_id", "other"), ("redirect_uri", "https://evil.test"),
                           ("grant_type", "client_credentials"), ("code_verifier", "short")]:
            with self.subTest(key=key), patch("src.zoom_oauth.urlopen") as upstream:
                original = self.data[key]
                self.data[key] = value
                with self.assertRaises(https_fn.HttpsError):
                    self.call(self.request())
                upstream.assert_not_called()
                self.data[key] = original

    def test_exchanges_with_fixed_zoom_endpoint_without_secret(self):
        response = {"access_token": "token", "refresh_token": "refresh", "expires_in": 3600}
        with patch("src.zoom_oauth.urlopen", return_value=io.BytesIO(json.dumps(response).encode())) as upstream:
            self.assertEqual(self.call(self.request()), response)
            request = upstream.call_args.args[0]
            self.assertEqual(request.full_url, "https://zoom.us/oauth/token")
            self.assertNotIn("Authorization", request.headers)
            self.assertEqual(parse_qs(request.data.decode())["code_verifier"], ["a" * 43])

    def test_refresh_sends_only_allowed_fields(self):
        self.data = {"client_id": "tFVInLKQUez_GgvV3PTg", "grant_type": "refresh_token",
                     "refresh_token": "refresh", "url": "https://evil.test"}
        response = {"access_token": "token", "refresh_token": "next", "expires_in": 3600}
        with patch("src.zoom_oauth.urlopen", return_value=io.BytesIO(json.dumps(response).encode())) as upstream:
            self.call(self.request())
            body = parse_qs(upstream.call_args.args[0].data.decode())
            self.assertEqual(set(body), {"client_id", "grant_type", "refresh_token"})

    def test_upstream_errors_do_not_echo_secrets(self):
        with patch("src.zoom_oauth.urlopen", side_effect=HTTPError("url", 400, "secret", {}, None)):
            with self.assertRaises(https_fn.HttpsError) as error:
                self.call(self.request())
            self.assertNotIn("secret", error.exception.message)


if __name__ == "__main__":
    unittest.main()
