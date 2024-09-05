import base64


def encode_to_base64(input_string):
    # Convert the string to bytes
    bytes_input = input_string.encode('utf-8')

    # Encode the bytes to Base64
    base64_bytes = base64.b64encode(bytes_input)

    # Convert Base64 bytes back to a string
    base64_string = base64_bytes.decode('utf-8')
    return base64_string
