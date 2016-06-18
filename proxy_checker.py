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


def check(address: str) -> bool:
    """ Check url:port status

    :param address: str
    :return:
    """
    res = requests.get('http://' + address, timeout=TIMEOUT)
    if res.status_code != 200:
        print('Request error [Code {0}]'.format(res.status_code), res.reason)
        return False
    return True


if __name__ == '__main__':
    # default value
    TIMEOUT = 120

    filename = os.path.dirname(os.path.realpath(__file__)) + '/proxy_list.txt'
    check_from_file(filename)
    print(filename)

    ''' TODO :: Parse input arguments via argsparse '''
