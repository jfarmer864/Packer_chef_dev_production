import configparser
from definitions import ROOT_DIR

__config = configparser.ConfigParser()
__config.read(ROOT_DIR + '/config.ini')



# Live pages
def itjobswatch_home_page_url():
    return __config['itjobswatchurls']['itjobswatch_home_page_url']

# Test Env setting
def get_test_env_setting():
    return __config['environment']['test_env']

# Test stub file locations

def itjobswatch_home_page_test_file():
    return ROOT_DIR + __config['itjobswatch_test_data']['itjobswatch_home_page_test_file']

