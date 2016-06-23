__author__ = 'shaunomeara'

from lib.libvirthlpr import libvirt_hlpr
from utils.utils import config_yaml
import argparse

def main_parser():
    # Setup Parser
    parser = argparse.ArgumentParser(description='Lab Builder Wrapper.',
                                     epilog='If you are struggling with this read the code')
    parser.add_argument('--collect',action='store_true', help='The collect portion of the tool')
    parser.add_argument('--conf', type=str, nargs='?',
                        help='Location of config.yaml - will look for it by default in the local dir')
    args = parser.parse_args()
    return vars(args)


def main():

    args = main_parser()

    if args['conf']:
        confs = config_yaml(args['conf'])
    else:
        confs = config_yaml('config/config.yaml')

    print confs


    lvh = libvirt_hlpr()
    lvh.get_info()

if __name__== "__main__":
    main()