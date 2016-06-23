__author__ = 'shaunomeara'

import yaml

def config_yaml(file):
    """
    load config from a yaml
    :param file:
    :return:
    """
    return yaml.load(open(file,"r"))