import sys
import requests

# Disable SSL warnings
requests.packages.urllib3.disable_warnings(
    requests.packages.urllib3.exceptions.InsecureRequestWarning
)

USERNAME = ""
PASSWORD = ""
LOGIN_URL = "https://hfw.vitap.ac.in:8090/login.xml"
LOGOUT_URL = "https://hfw.vitap.ac.in:8090/logout.xml"


def login():
    body = {"mode": 191, "username": USERNAME, "password": PASSWORD, "producttype": 0}
    response = requests.post(LOGIN_URL, data=body, verify=False)

    if "signed in as" in response.text:
        print("Logged in successfully.")
    elif "maximum login limit" in response.text:
        print("Maximum login limit reached.")
    else:
        print("Something went wrong. Failed to log in.")


def logout():
    body = {"mode": 193, "username": USERNAME, "password": PASSWORD, "producttype": 0}
    requests.post(LOGOUT_URL, data=body, verify=False)
    print("Logged out successfully.")


def print_help():
    print("Usage: python script.py [-l|-L] [-o|-O]")
    print(" -l, --login Log in to the Sophos Client")
    print(" -o, --logout Log out from the Sophos Client")
    print(" -h, --help Show this help message")


if len(sys.argv) == 1:
    print_help()
    sys.exit()

for arg in sys.argv[1:]:
    if arg.lower() in ["-l", "--login"]:
        login()
    elif arg.lower() in ["-o", "--logout"]:
        logout()
    elif arg.lower() in ["-h", "--help"]:
        print_help()
        sys.exit()
    else:
        print(f"Invalid option: {arg}")
        print_help()
        sys.exit(1)

if not USERNAME or not PASSWORD:
    print("Error: Username and password must be set.")
    sys.exit(1)
