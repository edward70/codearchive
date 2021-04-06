# tokens, etc. redacted lol, oh well
# OAUTH token fetching test
token_endpoint = "https://android.clients.google.com/auth"
def get_token():
    print('Requesting Token')
    request = urllib.Request(token_endpoint)
    request.add_header('device', '[REDACTED]')
    request.add_header('app', '[REDACTED]')
    request.add_header('User-Agent', 'GoogleAuth/1.4 (HWLUA-U6582 HUAWEILUA-U03); gzip')
    request.add_header('Connection', 'Keep-Alive')
    request.add_header('Accept-encoding', 'gzip')
    request.add_header('content-type', 'application/x-www-form-urlencoded')
    #request.add_header('content-length', '609')
    #app:[REDACTED]
    #service:https://www.googleapis.com/auth/plus.login
    data = {
    'androidId' : '[REDACTED]',
    'lang' : 'en_AU',
    'google_play_services_version': '14799007',
    'sdk_version': '22',
    'device_country': 'au',
    'request_visible_actions': '',
    'client_sig': '[REDACTED]',
    'caller_sig': '[REDACTED]',
    'Email': '[REDACTED]',
    'service': 'oauth2:https://www.googleapis.com/auth/plus.login',
    'app': '[REDACTED]',
    'check_email': '1',
    'token_request_options': 'CAA4AVAB',
    'system_partition': '1',
    'callerPkg': 'com.google.android.gms',
    'Token': '[REDACTED]'
    }
    data = bytes( parse.urlencode( data ).encode() )
    print(data)
    response = urllib.urlopen(request, data)
    final = None
    data = None
    if response.info().get('Content-Encoding') == 'gzip':
        buf = BytesIO(response.read())
        f = gzip.GzipFile(fileobj=buf)
        data = f.read()
        print('gzipped')
    else:
        data = response.read()
        print('no gzip')
    return data

import random

def get_register():
    print('Requesting Token')
    request = urllib.Request('https://[REDACTED]')
    request.add_header('Content-Type', 'application/json')
    request.add_header('Authorization', token)
    request.add_header('[REDACTED]-PLATFORM', 'ANDROID')
    request.add_header('[REDACTED]-DEVICE-MODEL', 'SAMSUNG')
    request.add_header('[REDACTED]-DEVICE-APP-VERSION', '1.9345.0001')
    request.add_header('[REDACTED]-ACCEPT-LANGUAGE', 'en')
    request.add_header('Connection', 'Keep-Alive')
    request.add_header('Accept-encoding', 'gzip')
    request.add_header('User-Agent', 'okhttp/3.10.0')
    #request.add_header('content-length', '609')
    #app:[REDACTED]
    #service:https://www.googleapis.com/auth/plus.login
    rand_id = ''.join(random.choice('0123456789abcdef') for n in range(11))
    data = '[REDACTED]'
    data = data % (rand_id)
    data = bytes( data.encode() )
    print(data)
    response = urllib.urlopen(request, data)
    final = None
    data = None
    if response.info().get('Content-Encoding') == 'gzip':
        buf = BytesIO(response.read())
        f = gzip.GzipFile(fileobj=buf)
        data = f.read()
        print('gzipped')
    else:
        data = response.read()
        print('no gzip')
    return data
