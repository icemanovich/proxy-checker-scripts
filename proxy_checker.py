import argparse
import requests
import os


def check_from_file(file):
    if not os.path.isfile(file):
        print('Input file does not available')

    with open(file, 'r') as f:
        for line in f:
            line = line.strip()
            status = check(line)
            print('[OK]  ' if status else '[Fail]')


def check(proxy_address: str, proxy_type: str='http') -> bool:
    """ Check proxy status by ping url address

    :param proxy_address: str
    :param proxy_type: str
    :return:
    """
    ip = ''
    if proxy_type:
        ip = proxy_type.lower() + '://' + proxy_address if proxy_type else 'http://' + proxy_address
        res = requests.get(URL, timeout=TIMEOUT, proxies={ip})
    else:
        res = requests.get(URL, timeout=TIMEOUT)
    if res.status_code != 200:
        print('Request error [Code {0}]'.format(res.status_code), res.reason)
        return False
    return True


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Great Description To Be Here')
    parser.add_argument('-u', '--url', help='Specify a target url address', required=False)
    parser.add_argument('-p', '--proxy', help='specify a proxy address:port to test [Example: 127.0.0.1:80]', required=False)
    parser.add_argument('-f', '--file', help='Specify a file with proxy to check', required=False)
    parser.add_argument('-t', '--timeout', help='Set timeout for each request (in seconds)', required=False)

    opts = parser.parse_args()

    # default value
    TIMEOUT = opts.timeout if opts.timeout else 120
    URL = opts.url if opts.url else "http://echoip.com"

    if opts.file:
        print('Check from list ::'.format(opts.file))
        check_from_file(opts.file)
    else:
        print('{0} -> {1} :: '.format(URL, opts.proxy), end='')
        check = check(URL, opts.proxy)
        print('Status :: {0}'.format(check))
